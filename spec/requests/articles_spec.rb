require 'rails_helper'


RSpec.describe "Articles", type: :request do
  describe "GET #new article" do
    it "リクエストが成功すること" do
      get new_article_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show article" do
    context "記事が存在する場合" do
      let(:user) { FactoryBot.create(:user, username: "alice") }
      let(:article) { user.articles.create(FactoryBot.attributes_for(:article, title: "test_title", content: "Hello Naoki")) }
      it "リクエストが成功すること" do
        get article_path(article)
        expect(response).to have_http_status(200)
      end
      it "投稿者が表示されること" do
        get article_path(article)
        expect(response.body).to include "alice"
      end
      it "タイトルが表示されること" do
        get article_path(article)
        expect(response.body).to include "test_title"
      end
      it "本文が表示されること" do
        get article_path(article)
        expect(response.body).to include "Hello Naoki"
      end
    end
    context "記事が存在しない場合" do
      subject { -> {get article_path("abc")} }
      it { is_expected.to raise_error (ActiveRecord::RecordNotFound) }
    end
  end

  
  describe "GET #index article" do
    it "ルートにリダイレクトすること" do
      get articles_path
      expect(response).to redirect_to root_path
    end
  end
  
  describe "POST #create article" do
    let(:user) { FactoryBot.create(:user) }
    context "パラメーターが妥当な場合" do
      let(:valid_params) { FactoryBot.attributes_for(:article) }
      it "リクエストが成功すること" do
        post articles_path, params: { article: valid_params }
        expect(response).to have_http_status(302)
      end
      it "記事が登録されること" do
        expect do
          post articles_path, params: { article: valid_params }
        end.to change(Article, :count).by(1)
      end
      it "リダイレクトされること" do
        post articles_path, params: { article: valid_params }
        expect(response).to redirect_to article_path(Article.last)
      end
    end
    context "パラメーターが不正な場合" do
      let(:invalid_params) { FactoryBot.attributes_for(:article, title: "") }
      it "リクエストが成功すること" do
        post articles_path, params: { article: invalid_params }
        expect(response).to have_http_status(200)
      end
      it "記事が登録されないこと" do
        expect do
          post articles_path, params: { article: invalid_params }
        end.to_not change(Article, :count)
      end
      it "エラーが表示されること" do
        post articles_path, params: { article: invalid_params }
        expect(response.body).to include "can&#39;t be blank"
      end
    end
  end
  
  describe "GET #edit article" do
    let!(:user) { FactoryBot.create(:user, username: "alice") }
    let!(:invalid_user) { FactoryBot.create(:user, username: "Jhon")}
    let!(:article) { user.articles.create(FactoryBot.attributes_for(:article, title: "test_title", content: "Hello Naoki")) }
    context "妥当なuserでログインしている場合" do
      before do
        sign_in(user)
      end
      it "リクエストが成功すること" do
        get edit_article_path(article), params: { article_token: "" }
        expect(response).to have_http_status(200)
      end
      it "タイトルが表示されること" do
        get edit_article_path(article), params: { article_token: "" }
        expect(response.body).to include "test_title"
      end
      it "本文が表示されること" do
        get edit_article_path(article), params: { article_token: "" }
        expect(response.body).to include "Hello Naoki"
      end
    end
    context "不正なuserでログインしている場合" do
      before do
        sign_in(invalid_user)
      end
      it "リクエストが成功すること" do
        get edit_article_path(article), params: { article_token: "" }
        expect(response).to have_http_status(302)
      end
      it "リダイレクトされること" do
        get edit_article_path(article), params: { article_token: "" }
        expect(response).to redirect_to article_path(article)
      end
    end
    context "article_tokenが正しい場合" do
      it "リクエストが成功すること" do
        get edit_article_path(article), params: { article_token: article.article_token }
        expect(response).to have_http_status(200)
      end
      it "タイトルが表示されること" do
        get edit_article_path(article), params: { article_token: article.article_token }
        expect(response.body).to include "test_title"
      end
      it "本文が表示されること" do
        get edit_article_path(article), params: { article_token: article.article_token }
        expect(response.body).to include "Hello Naoki"
      end
    end
    context "article_tokenが不正な場合" do
      it "リクエストが成功すること" do
        get edit_article_path(article), params: { article_token: "" }
        expect(response).to have_http_status(302)
      end
      it "リダイレクトすること" do
        get edit_article_path(article), params: { article_token: "" }
        expect(response).to redirect_to article_path(article)
      end
    end
  end

  describe "PUT #update" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:article) { user.articles.create(FactoryBot.attributes_for(:article, title: "title", content: "content"))}
    context "パラメーターが妥当な場合" do
      let(:valid_params) { FactoryBot.attributes_for(:article, title: "new title", content: "new content") }
      it "リクエストが成功すること" do
        put article_path(article), params: { article_token: article.article_token, article: valid_params }
        expect(response).to have_http_status(302)
      end
      it "titleが更新されること" do
        expect do
          put article_path(article), params: { article_token: article.article_token, article: valid_params }
        end.to change { Article.find_by(url_token: article.url_token).title }.from("title").to("new title")
      end
      it "contentが更新されること" do
        expect do
          put article_path(article), params: { article_token: article.article_token, article: valid_params }
        end.to change { Article.find_by(url_token: article.url_token).content }.from("content").to("new content")
      end
      it "リダイレクトすること" do
        put article_path(article), params: { article_token: article.article_token, article: valid_params }
        expect(response).to redirect_to article_path(article)
      end
    end
    context "パラメーターが不正な場合" do
      let(:invalid_params) { FactoryBot.attributes_for(:article, title: "a"*101, content: "")}
      it "リクエストが成功する" do
        put article_path(article), params: { article_token: article.article_token, article: invalid_params }
        expect(response).to have_http_status(200)
      end
      it "titleが変更されないこと" do
        expect do
          put article_path(article), params: { article_token: article.article_token, article: invalid_params }
        end.to_not change(Article.find_by(url_token: article.url_token), :title)
      end
      it "contentが変更されないこと" do
        expect do
          put article_path(article), params: { article_token: article.article_token, article: invalid_params }
        end.to_not change(Article.find_by(url_token: article.url_token), :content)
      end
      it "errorが表示されること" do
        put article_path(article), params: { article_token: article.article_token, article: invalid_params }
        expect(response.body).to include "can&#39;t be blank"
      end
    end
    context "article_tokneが不正な場合" do
      let(:valid_params) { FactoryBot.attributes_for(:article, title: "new title", content: "new content") }
      it "リクエストが成功すること" do
        put article_path(article), params: { article_token: "", article: valid_params }
        expect(response).to have_http_status(302)
      end
      it "titleが変更されないこと" do
        expect do
          put article_path(article), params: { article_token: "", article: valid_params }
        end.to_not change(Article.find_by(url_token: article.url_token), :title)
      end
      it "contentが変更されないこと" do
        expect do
          put article_path(article), params: { article_token: "", article: valid_params }
        end.to_not change(Article.find_by(url_token: article.url_token), :content)
      end
      it "リダイレクトされること" do
        put article_path(article), params: { article_token: "", article: valid_params }
        expect(response).to redirect_to article_path(article)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:user) { FactoryBot.create(:user, username: "Alice") }
    let!(:invalid_user) { FactoryBot.create(:user, username: "Jhon")}
    let!(:article) { user.articles.create(FactoryBot.attributes_for(:article))}
    context "妥当なユーザーでログインしている場合" do
      before do
        sign_in(user)
      end
      it "リクエストが成功すること" do
        delete article_path(article), params: { article_token: "" }
        expect(response).to have_http_status(302)
      end
      it "記事が削除されること" do
        expect do
          delete article_path(article), params: { article_token: "" }
        end.to change(Article, :count).by(-1)
      end
      it "リダイレクトすること" do
        delete article_path(article), params: { article_token: "" }
        expect(response).to redirect_to root_path
      end
    end
    context "不正なユーザーでログインしている場合" do
      before do
        sign_in(invalid_user)
      end
      it "リクエストが成功すること" do
        delete article_path(article), params: { article_token: "" }
        expect(response).to have_http_status(302)
      end
      it "記事が削除されないこと" do
        expect do
          delete article_path(article), params: { article_token: "" }
        end.to_not change(Article, :count)
      end
      it "リダイレクトすること" do
        delete article_path(article), params: { article_token: "" }
        expect(response).to redirect_to article_path(article)
      end
    end
    context "article_tokenが正しい場合" do 
      it "リクエストが成功すること" do
        delete article_path(article), params: { article_token: article.article_token }
        expect(response).to have_http_status(302)
      end
      it "記事が削除されること" do
        expect do
          delete article_path(article), params: { article_token: article.article_token }
        end.to change(Article, :count).by(-1)
      end
      it "リダイレクトすること" do
        delete article_path(article), params: { article_token: article.article_token }
        expect(response).to redirect_to root_path
      end
    end
    context "article_tokenが不正な場合" do
      it "リクエストが成功すること" do
        delete article_path(article), params: { article_token: "" }
        expect(response).to have_http_status(302)
      end
      it "記事が削除されないこと" do
        expect do
          delete article_path(article), params: { article_token: "" }
        end.to_not change(Article, :count)
      end
      it "リダイレクトすること" do
        delete article_path(article), params: { article_token: "" }
        expect(response).to redirect_to article_path(article)
      end
    end
  end

end
