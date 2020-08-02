require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET sessions#new user" do
    it "リクエストが成功すること" do
      get new_user_session_path
      expect(response).to have_http_status(200)
    end
  end
  
  describe "GET #new user" do
    it "リクエストが成功すること" do
      get new_user_registration_path
      expect(response).to have_http_status(200)
    end
  end
  
  describe "GET #edit user" do
    let!(:user) { FactoryBot.create(:user) }
    it "レスポンスが成功すること" do
      sign_in(user)
      get edit_user_registration_path
      expect(response).to have_http_status(200)
    end
    it "emailが表示されること" do
      sign_in(user)
      get edit_user_registration_path
      expect(response.body).to include user.email
    end
    it "passwordが表示されること" do
      sign_in(user)
      get edit_user_registration_path
      expect(response.body).to include user.password
    end
  end

  describe "POST #create user" do
    context "パラメーターが妥当な場合" do
      let(:valid_params) { FactoryBot.attributes_for(:user) }
      it "リクエストが成功すること" do
        post user_registration_path, params: { user: valid_params }
        expect(response).to have_http_status(302)
      end
      it "userが登録されること" do
        expect do
          post user_registration_path, params: { user: valid_params }
        end.to change(User, :count).by(1)
      end
      it "リダイレクトが成功すること" do
        post user_registration_path, params: { user: valid_params }
        expect(response).to redirect_to root_path
      end
    end
    context "パラメーターが不正な場合" do
      let(:invalid_params) {FactoryBot.attributes_for(:user, username: "", email: "", password: "", password_confirmation: "")}
      it "リクエストが成功すること" do
        post user_registration_path, params: { user: invalid_params }
        expect(response).to have_http_status(200)
      end
      it "userが登録されないこと" do
        expect do
          post user_registration_path, params: { user: invalid_params }
        end.not_to change(User, :count)
      end
      it "errorが表示されること" do
        post user_registration_path, params: { user: invalid_params }
        expect(response.body).to include "4 errors prohibited this user from being saved"
      end
    end
  end

  describe "PUT #update user" do
    let!(:user) { FactoryBot.create(:user, email: "email@example.com", password: "password", password_confirmation: "password") }
    context "ログインしていない場合" do
      let(:valid_params) { FactoryBot.attributes_for(:user) }
      it "リクエストが成功すること" do
        delete user_registration_path
        expect(response).to have_http_status(302)
      end
      it "リダイレクトされること" do
        put user_registration_path, params: { user: valid_params }
        expect(response).to redirect_to new_user_session_path
      end
    end
    context "パラメーターが妥当な場合" do
      let(:valid_params) { FactoryBot.attributes_for(:user, email: "new_email@example.com", password: "new_password", password_confirmation: "new_password", current_password: "password") }
      it "リクエストが成功すること" do
        sign_in(user)
        put user_registration_path, params: { user: valid_params }
        expect(response).to have_http_status(302)
      end
      it "emailが変更されること" do
        sign_in(user)
        expect do
          put user_registration_path, params: { user: valid_params }
        end.to change { User.find(user.id).email }.from("email@example.com").to("new_email@example.com")
      end
      it "リダイレクトされること" do
        sign_in(user)
        put user_registration_path, params: { user: valid_params }
        expect(response).to redirect_to root_path
      end
    end
    context "パラメーターが不正な場合" do
      let(:invalid_params) { FactoryBot.attributes_for(:user, password: "new_password", password_confirmation: "", current_password: "password") }
      it "リクエストが成功すること" do
        sign_in(user)
        put user_registration_path, params: { user: invalid_params }
        expect(response).to have_http_status(200)
      end
      it "errorが表示されること" do
        sign_in(user)
        put user_registration_path, params: { user: invalid_params }
        expect(response.body).to include "error"
      end
    end
  end

  describe "DELETE #destroy user" do
    let!(:correct_user) { FactoryBot.create(:user) }
    let!(:another_user) { FactoryBot.create(:user) }
    context "ログインしていない場合" do
      it "リクエストが成功すること" do
        delete user_registration_path
        expect(response).to have_http_status(302)
      end
      it "userが削除されないこと" do
        expect do
          delete user_registration_path
        end.not_to change(User, :count)
      end
      it "リダイレクトされること" do
        delete user_registration_path
        expect(response).to redirect_to new_user_session_path
      end
    end
    context "ログインしている場合" do
      it "リクエストが成功すること" do
        sign_in(correct_user)
        delete user_registration_path
        expect(response).to have_http_status(302)
      end
      it "userが削除されること" do
        expect do
          sign_in(correct_user)
          delete user_registration_path
        end.to change(User, :count).by(-1)
      end
      it "リダイレクトされること" do
        sign_in(correct_user)
        delete user_registration_path
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "GET #show user" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:article) { user.articles.create(FactoryBot.attributes_for(:article)) }
    it "リクエストが成功すること" do
      get user_path(user)
      expect(response).to have_http_status(200)
    end
    it "記事のタイトルが表示されること" do
      get user_path(user)
      expect(response.body).to include article.title
    end
    it "記事へのリンクが含まれること" do
      get user_path(user)
      expect(response.body).to include article_path(article)
    end
    context "userが存在しない場合" do
      subject { -> { get user_path("abc") } }
      it { is_expected.to raise_error (ActiveRecord::RecordNotFound) }
    end
  end
end
