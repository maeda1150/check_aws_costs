#!/bin/sh

echo `date +%Y-%m-%d_%H:%M:%S`
bundle exec ruby sync_cost.rb
bundle exec ruby post_cost.rb
