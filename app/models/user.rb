class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_uniqueness_of :email

  before_save :fix_case

  def fix_case
    self.email = self.email.downcase
  end

  def saved_searches
    saved_searches = SavedSearch.new
    return saved_searches.all(self.id)
  end

  def saved_search_results
    return SavedSearchResult.all(self.id)
  end
end
