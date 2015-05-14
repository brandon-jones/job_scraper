require 'rails_helper'

RSpec.describe EmailQueue, type: :model do
  it "should know its redis key" do
    eq = EmailQueue.new.key
    expect(eq).to eq('email_queue')
  end

  it "return an empty array if no users need to be emailed" do
    eq = EmailQueue.all
    expect(eq).to eq([])
  end

  it 'should allow me to add an intger to members' do
    user = FactoryGirl.create(:user)
    EmailQueue.add(user.id)
    expect(EmailQueue.all).to eq([user.id.to_s])
  end

  it "should not allow duplicate user ids" do
    user = FactoryGirl.create(:user)
    EmailQueue.add(user.id)
    EmailQueue.add(user.id)
    expect(EmailQueue.all).to eq([user.id.to_s])
  end

  it "should return an array of user ids" do
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user, id: 2, email: '1@1.com')
    user3 = FactoryGirl.create(:user, id: 3, email: '2@2.com')
    EmailQueue.add(user1.id)
    EmailQueue.add(user2.id)
    EmailQueue.add(user3.id)
    expect(EmailQueue.all.length).to eq(3)
    expect(EmailQueue.all).to include(user1.id.to_s)
    expect(EmailQueue.all).to include(user2.id.to_s)
    expect(EmailQueue.all).to include(user3.id.to_s)
  end

  it "should clear the redis array when calling pop" do
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user, id: 2, email: '1@1.com')
    user3 = FactoryGirl.create(:user, id: 3, email: '2@2.com')
    EmailQueue.add(user1.id)
    EmailQueue.add(user2.id)
    EmailQueue.add(user3.id)
    email_list = EmailQueue.pop_all

    expect(EmailQueue.all).to be([])
    expect(email_list.length).to eq(3)
    expect(email_list).to include(user1.id.to_s)
    expect(email_list).to include(user2.id.to_s)
    expect(email_list).to include(user3.id.to_s)
  end
end
