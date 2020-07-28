require 'rails_helper'

RSpec.describe Article, type: :article do
  let(:user) { FactoryBot.build(:user) }
  context "title, contentが存在すれば登録できること" do
    subject { user.articles.build(FactoryBot.attributes_for(:article)) }
    it { is_expected.to be_valid }
  end
  context "titleが存在しない場合、登録できないこと" do
    subject { user.articles.build(FactoryBot.attributes_for(:article, title: "")) }
    it { is_expected.to be_invalid }
  end
  context "titleが100文字の場合、登録できること" do
    subject { user.articles.build(FactoryBot.attributes_for(:article, title: "a"*100)) }
    it { is_expected.to be_valid }
  end
  context "titleが101文字の場合、登録できないこと" do
    subject { user.articles.build(FactoryBot.attributes_for(:article, title: "a"*101)) }
    it { is_expected.to be_invalid }
  end
  context "contentが存在しない場合、登録できないこと" do
    subject { user.articles.build(FactoryBot.attributes_for(:article, content: "")) }
    it { is_expected.to be_invalid }
  end

end