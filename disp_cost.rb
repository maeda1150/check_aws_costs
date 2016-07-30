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

aws_configs = Util.load_yaml('aws_config.yml', 'aws_config')

aws_configs.each do |config|
  puts '=' *45
  puts " #{ config['profile'] }"
  puts '-' * 45
  puts " #{ Util.resize_len('time', 20) } : #{ Util.resize_len('value', 20) }"
  puts '-' * 45
  costs = Cost.where(profile: config['profile'])
              .where('costs.time < ?', Time.current - 30)
              .order(:time)
  costs.each do |cost|
    puts " #{ Util.resize_len(cost.time.to_s, 20) } : #{ Util.resize_len(cost.value.to_s, 20) } "
  end
end
puts '=' * 45
