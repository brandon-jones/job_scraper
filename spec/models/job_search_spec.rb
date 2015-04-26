require 'rails_helper'

RSpec.describe JobSearch, type: :model do
  it "should require a name" do
    js = FactoryGirl.build(:job_search)
    expect(js.save).to be_falsy
  end
end
