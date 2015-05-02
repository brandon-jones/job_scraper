class WeWorkRemotely < JobSearch
  attr_accessor :search_terms, :category

  def category_options
    return JSON.parse(self.options)["categories"]
  end

  # def get_category(saved_search)
  #   JSON.parse(self.options)['categories'].each { |category| return category[0] if category[1] == saved_search.category}
  #   return ''
  # end

  def self.convert_date(date)
    return Date.new(Time.now.utc.year, Date::ABBR_MONTHNAMES.index(date.split(' ')[0]), date.split(' ')[1].to_i)
  end

  def get_search_term(data)
    return data["search_terms"]
  end

  def get_category(data)
    JSON.parse(self.options)['categories'].each { |category| return category[0] if category[1] == data.category}
    return ''
  end

  def headers
    return ['Search Term', 'Category']
  end

  def build_search_results(requested_results, result)
    noko_body = Nokogiri::HTML(result)
    search_results = []
    noko_body.css("#category-#{requested_results.category}").each do |section|
      section.css('li').each do |section_li|
        results_hash = {}
        results_hash['company'] = section_li.css('.company').text if section_li.css('.company').text.present?
        results_hash['title'] = section_li.css('.title').text if section_li.css('.title').text.present?
        results_hash['date_str'] = section_li.css('.date').text if section_li.css('.date').text.present?
        results_hash['link'] =  "https://weworkremotely.com#{section_li.css('a')[0]['href']}" if section_li.css('a')[0]['href'].present?
        results_hash['type'] = self.type
        search_results << results_hash if results_hash.keys.count > 2
      end
    end
    return search_results
  end
end
