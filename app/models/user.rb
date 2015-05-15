class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates_uniqueness_of :email

  before_save :fix_case

  def fix_case
    self.email = self.email.downcase
  end

  def saved_searches
    return SavedSearch.all self
  end

  def saved_search_results
    return SavedSearchResult.all self
  end

  def notify_new_jobs
    if self.confirmed_at
      options = {
      :subject => "Job Hunt Jobs Updated",
      :email => self.email,
      :global_merge_vars => [
        {
          name: "email",
          content: "#{self.email}"
        },
        {
          name: "job_link",
          content: "#{$domain}/users/#{self.id}/saved_searches"
        }
      ],
      :template => "updated-jobs"
      }

      MyMailer.mandrill_send options
    end
  end
end
