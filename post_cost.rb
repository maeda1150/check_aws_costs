require 'aws-sdk'
require 'optparse'
require 'json'
require 'yaml'
require 'erb'
require 'pry'
require 'active_record'
require 'slack'
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
slack_config = Util.load_yaml('slack_config.yml', 'aws_config')

Slack.configure do |config|
  config.token = slack_config['token']
end

def post_slack(profile, time, value)
  Slack.chat_postMessage(
    text: "profile: #{ profile }  cost: #{ value.to_s }  time: #{ time.to_s }",
    channel: 'aws_cost'
  )
end

# start CloudWatch
start_time = Time.now
puts 'Start post cost to slack'

aws_configs.each do |config|
  latests = Cost.latest_two(config['profile'])
  if (latests.first.value != latests.second.value) && (latest.first.created_at > Time.current - 5.minutes)
    post_slack(
      latests.first.profile,
      latests.first.time,
      latests.first.value
    )
  end
end

puts "post to slack cost time : #{Time.now - start_time} second"
