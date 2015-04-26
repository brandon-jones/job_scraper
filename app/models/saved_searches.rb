class SavedSearches

  def self.clean_params(data)
    if data["we_work_remotely"]
      data["saved_searches"] = data['we_work_remotely']
      return data.except('we_work_remotely')
    end
  end
end
