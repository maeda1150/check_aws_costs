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
puts 'Start post cost to slack'

aws_configs.each do |config|
  latests = Cost.latest_two(config['profile'])
  if (latests.first.value != latests.second.value) && (latest.first.created_at > Time.current - 5.minutes)
    slack = Slack::Incoming::Webhooks.new slack_config['webhook_url']
    slack.post "profile: #{ latests.first.profile }  "\
               "cost: #{ latests.first.value.to_s }  "\
               "time: #{ latests.first.time.to_s }"
  end
end

puts "post to slack cost time : #{Time.now - start_time} second"
