FactoryGirl.define do
  factory :job_search do
    name 'We Work Remotly'
    description 'remote only jobs'
    image 'http://i.imgur.com/2sbJ7Oo.jpg'
    options "{ 'categories' => { '2' => 'programming' }, 'search_terms' => ['ruby on rails', 'jr dev'] }"
    homepage 'https://weworkremotely.com'
    search_url 'https://weworkremotely.com/jobs/search?term={{search_terms}}'
  end
end
