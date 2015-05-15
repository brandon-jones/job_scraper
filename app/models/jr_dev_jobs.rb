class JrDevJobs < JobSearch
  attr_accessor :search_terms

  def self.convert_date(date)
    return Date.new(Time.now.utc.year, date.split('/')[0].to_i, date.split('/')[1].to_i)
  end

  def get_search_term(data)
    return data["search_terms"]
  end

  def headers
    return ['Search Term']
  end

  def build_search_results(requested_results, result)
    noko_body = Nokogiri::HTML(result)
    search_results = []
    noko_body.css(".table.table-hover.squeeze-table tbody tr").each do |section|
      cols = section.css('td')

      results_hash = {}

      results_hash['date_str'] =  cols[0].text
      results_hash['company'] =  cols[1].text.strip.split('at')[1].strip
      results_hash['title'] =  cols[1].text.strip.split('at')[0].strip
      results_hash['link'] =  "http://www.jrdevjobs.com/#{cols[1].css('a')[0]['href']}" if section.css('a')[0]['href'].present?
      results_hash['type'] = self.type
      results_hash['location'] = cols[2].text.strip
      results_hash['schedule'] = cols[3].text

      search_results << results_hash if results_hash.keys.count > 2
    end
    return search_results
  end
end
