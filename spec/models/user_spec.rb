require 'rails_helper'

describe User do
  describe "#create" do
    it "username, email, password, password confiramationが存在すれば登録できること" do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end
    describe "username" do
      subject(:user) { FactoryBot.build(:user, username: username) }
      context "usernameが存在しない場合登録できないこと" do
        let(:username) { "" }
        it { is_expected.to be_invalid }
      end
      context "usernameが12文字の場合登録できること" do
        let(:username) { "a"*12 }
        it { is_expected.to be_valid }
      end
      context "usernameが13文字の場合登録できないこと" do
        let(:username) { "a"*13 }
        it { is_expected.to be_invalid }
      end
      context "usernameが重複している場合" do
        existed_user =  User.find_by(username: "existed_user") || FactoryBot.create(:existed_user)
        let(:username) { existed_user.username }
      end
    end
    describe "email" do
      subject(:user) { FactoryBot.build(:user, email: email) }
      context "emailが存在しない場合" do
        let(:email) { "" }
        it { is_expected.to be_invalid }
      end
      context "emailが重複してする場合" do
        existed_user =  User.find_by(username: "existed_user") || FactoryBot.create(:existed_user)
        let(:email) { existed_user.email }
        it { is_expected.to be_invalid }
      end
    end
    describe "password" do
      subject(:user) { FactoryBot.build(:user, password: password, password_confirmation: password_confirmation) }
      context "passwordが存在しない場合" do
        let(:password) { "" }
        let(:password_confirmation) { "password" }
        it { is_expected.to be_invalid }
      end
      context "passwordが存在しても、password confirmationが存在しない場合" do
        let(:password) { "passowrd" }
        let(:password_confirmation) { "" }
        it { is_expected.to be_invalid }
      end
      context "passwordがpasword_confirmationと一致しない場合" do
        let(:password) { "password_a" }
        let(:password_confirmation) { "password_b" }
        it { is_expected.to be_invalid }
      end
      context "passwordが7文字の場合" do
        let(:password) { "a"*7 }
        let(:password_confirmation) { "a"*7 }
        it { is_expected.to be_invalid }
      end
      context "passwordが8文字の場合" do
        let(:password) { "a"*8 }
        let(:password_confirmation) { "a"*8 }
        it { is_expected.to be_valid }
      end
    end
  end
end