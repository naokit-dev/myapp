class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :article_authentication, only:[:edit, :destroy]

  def index
    redirect_to root_path
    # @articles = Article.all
  end

  def show
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
      author = current_user
    else
      author = User.mdguest
    end
    @article = author.articles.build(article_params)
    if @article.save
      flash[:need_to_confirm] = @article.article_token
      redirect_to @article
    else
        render :new
    end
  end


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


  def destroy
    @article.destroy
    redirect_to root_path, notice: 'Article was successfully destroyed.' 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find_by!(url_token: params[:url_token])
      @author = @article.user
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :content, :url_token, :article_token)
    end

    def article_authentication
      if user_signed_in?
        unless current_user == @author
          redirect_to @article
          flash[:alert] = "Invalid password or Permission denied"
        end
      else
        unless @article.authenticate_article_token(params[:article_token])
          redirect_to @article
          flash[:alert] = "Invalid password or Permission denied"
        end
      end
    end

end
