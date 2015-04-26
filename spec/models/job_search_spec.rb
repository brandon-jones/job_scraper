require 'rails_helper'

RSpec.describe JobSearch, type: :model do
  it "should require a name" do
    js = FactoryGirl.build(:job_search, name: '')
    expect(js.save).to be_falsy
    js.update_attribute(:name, 'testing')
    expect(js.save).to be_truthy
  end

  it "should require a unique name" do
    js = FactoryGirl.create(:job_search, name: 'testing')
    js2 = FactoryGirl.build(:job_search, name: js.name)
    expect(js2.save).to be_falsy
    js.update_attribute(:name, 'not testing')
    expect(js2.save).to be_truthy
  end
end
