require 'rails_helper'

RSpec.describe SavedSearch, type: :model do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @job_search = FactoryGirl.create(:job_search)
  end

  it "should save job_search info" do

  end
end
