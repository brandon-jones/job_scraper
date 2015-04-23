require 'rails_helper'

RSpec.describe User, type: :model do
  it "should have an email" do
    user = Factory.new(:user, password: '')

  end
end
