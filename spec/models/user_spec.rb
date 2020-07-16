require 'rails_helper'

describe User do
  before do
    @user = FactoryBot.build(:user)
  end

    it "username, email, password, password confiramationが存在すれば登録できること" do
      expect(@user).to be_valid
    end

end