# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

JobSearch.create(name: 'We Work Remotely', description: 'Remote only Jobs', image: 'https://weworkremotely.com/images/header.jpg', 
                 options: "{ 'categories' => { '1' => 'design', '2' => 'programming', '3' => 'buisness exec', '4' => 'miscellaneous', '5' => 'copywriter', '6' => 'sys admin', '7' => 'customer service/support' } }",
                 homepage: 'https://weworkremotely.com', search_url: 'https://weworkremotely.com/jobs/search?term={{search_terms}}',
                 type: 'WeWorkRemotely')