# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# JobSearch.create(name: 'We Work Remotely', 
#                  description: 'Remote only Jobs', 
#                  image: 'https://weworkremotely.com/images/header.jpg', 
#                  options: "{\"categories\":[[\"design\",\"1\"],[\"programming\",\"2\"],[\"buisness exec\",\"3\"],[\"miscellaneous\",\"4\"],[\"copywriter\",\"5\"],[\"sys admin\",\"6\"],[\"customer service/support\",\"7\"]],\"search terms\":\"\"}",
#                  homepage: 'https://weworkremotely.com', 
#                  search_url: 'https://weworkremotely.com/jobs/search?term={{search_terms}}',
#                  type: 'WeWorkRemotely')

JobSearch.create(name: 'Jr Dev Jobs', 
                 description: 'Junior only jobs', 
                 image: 'http://i.imgur.com/vAQhZcX.png', 
                 options: "{search terms\":\"\"}", 
                 homepage: 'http://www.jrdevjobs.com/', 
                 search_url: "http://www.jrdevjobs.com/jobs?utf8=%E2%9C%93&query={{search_terms}}",
                 type: 'JrDevJobs')

# JobSearch.create(name:, 
#                  description:, 
#                  image:, 
#                  options:, 
#                  homepage:, 
#                  search_url:,
#                  type:)