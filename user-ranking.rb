#!/usr/bin/env ruby

require 'discourse_api'
require 'date'
require 'yaml'

api_key = ENV['DISCOURSE_API_KEY'] || raise('Please export DISCOURSE_API_KEY.')
api_user = ENV['DISCOURSE_API_USER'] || raise('Please export DISCOURSE_API_USER')
api_base = ENV['DISCOURSE_API_BASE'] || 'https://ask.cyberinfrastructure.org'

# Initialize Client
client = DiscourseApi::Client.new(api_base)
client.api_key = api_key
client.api_username = api_user

# Get groups, create lookup with list of member ids
puts "Looking up members by group"
groups = client.groups

# Note that per the API token limits (60/min for admin) we have to slow down
puts "Calculating contribution totals for last month..."

lookup = Hash.new
users = Hash.new
groups["groups"].each { |group|

  # Keep record of user and group contributions
  lookup[group["name"]] = 0  
  users[member["username"]] +=1

  # For each member, calculate contributes for last month
  client.group_members(group["name"]).each { |member|
    sleep(1)
    client.user_topics_and_replies(member["username"]).each { |activity|
      if DateTime.parse(activity["created_at"]).to_date >= Date.today.prev_month
        lookup[group["name"]] += 1
        users[member["username"]] +=1
      end
    }
  }
}

puts "Contributions since " + Date.today.prev_month.strftime
puts lookup.to_yaml

# Save to json depending on month
if not  File.directory?('data')
  puts "Creating output directory, data"
  Dir.mkdir "data"
end

# Write output to yaml file
File.open("data/groups-" + Date.today.prev_month.strftime + "yml" , "w") { |file| file.write(lookup.to_yaml) }
File.open("data/users-" + Date.today.prev_month.strftime + "yml" , "w") { |file| file.write(users.to_yaml) }
