class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  def index
    @articles = Article.all
  end

  def show
    # @article = Article.find_by(url_token: params[:url_token])
    @writer = @article.user
  end

  def new
    if user_signed_in?
      @article = current_user.articles.build
    else
      @article = User.mdguest.articles.build
    end
  end

  def edit
  end

  def create
    if user_signed_in?
      @article = current_user.articles.build(article_params)
    else
      @article = User.mdguest.articles.build(article_params)
      @article.guest_author = true
    end
    @article.guest_token = SecureRandom.hex(4)
    if @article.save
      unless user_signed_in?
        flash[:alert] = "記事固有パスワード: #{@article.guest_token} ***記事の編集や削除に必要です***"
      end
      flash[:notice] = 'Article was successfully created.'
      redirect_to @article
    else
        render :new
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find_by(url_token: params[:url_token])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :content, :url_token, :guest_token, :guest_author)
    end
end
