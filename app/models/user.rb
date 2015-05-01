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
    saved_searches = SavedSearches.new
    return saved_searches.all(self)
  end
end
