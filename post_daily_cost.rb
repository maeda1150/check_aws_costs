require 'json'
require 'yaml'
require 'erb'
require 'pry'
require 'active_record'
require 'active_support'
require 'slack/incoming/webhooks'

Dir.glob("#{File.expand_path('../classes', __FILE__)}/*.rb").each do |file|
  require file
end

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: './database/aws_cost.sqlite'
)

# Set Config
aws_configs = Util.load_yaml('aws_config.yml', 'aws_config')
slack_config = Util.load_yaml('slack_config.yml', 'aws_config')

# start CloudWatch
start_time = Time.now
puts 'Start post daily cost to slack'

slack = Slack::Incoming::Webhooks.new slack_config['webhook_url']
post_str = ''

aws_configs.each do |config|
  latest = Cost.where(profile: config['profile']).order(time: :desc).first
  post_str << "profile: #{ latest.profile }  "\
              "cost: #{ latest.value.to_s }  "\
              "time: #{ latest.time.to_s }\n"
end

slack.post post_str

puts "post to slack cost time : #{Time.now - start_time} second"
