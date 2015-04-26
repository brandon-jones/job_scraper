require 'rails_helper'

RSpec.describe User, type: :model do
  it "should have an email" do
    user = FactoryGirl.build(:user, email: '')
    expect(user.save).to be_falsy
    user.update_attribute(:email, 'bob@bob.com')
    expect(user.save).to be_truthy
  end

  it "should have a unique email" do
    user = FactoryGirl.create(:user)
    user2 = FactoryGirl.build(:user, email: user.email)
    expect(user2.save).to be_falsy
    user2.update_attribute(:email, 'i@am.email')
    expect(user2.save).to be_truthy
  end

  it "should have a password" do
    user = FactoryGirl.build(:user, password: '')
    expect(user.save).to be_falsy
    user.update_attribute(:password, 'password')
    expect(user.save).to be_truthy
  end

  it "should lower case the email" do
    user = FactoryGirl.create(:user, email: "BOB@BOB.com")
    expect(user.email).to eq("bob@bob.com")
  end
end
