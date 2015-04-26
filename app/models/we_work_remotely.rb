class WeWorkRemotely < JobSearch
  attr_accessor :search_terms, :category

  def category_options
    return JSON.parse(self.options)["categories"]
  end
end
