require 'aws-sdk'
require 'optparse'
require 'json'
require 'yaml'
require 'erb'
require 'pry'
require 'active_record'
require 'active_support'

Dir.glob("#{File.expand_path('../classes', __FILE__)}/*.rb").each do |file|
  require file
end

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: './database/aws_cost.sqlite'
)


# Set Config
aws_configs = Util.load_yaml('aws_config.yml', 'aws_config')

# start CloudWatch
start_time = Time.current
puts 'Start sync_cost task.'

current_time = Time.current

aws_configs.each do |config|
  credentials = Aws::Credentials.new(config['access_key_id'], config['secret_access_key'])
  Aws.config.update(region: 'us-east-1', credentials: credentials)

  cw = CloudWatch.new

  1..20.times do |t|
    met = cw.get_metric_statistics(current_time - (t + 1).days, current_time - t.days)
    met.datapoints.sort! { |a, b| b[:timestamp] <=> a[:timestamp] }

    met.datapoints.each do |data|
      Cost.upsert(profile: config['profile'],
                  time: data.timestamp,
                  value: data.maximum.to_s)
    end
  end
end

puts "sync cost time : #{Time.current - start_time} second"
