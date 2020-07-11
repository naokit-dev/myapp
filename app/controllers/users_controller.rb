class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

 
  # GET /users/1
  def show
    @user = User.find(params[:id])
    @articles = @user.articles.page(params[:page]).per(5).order('updated_at DESC')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.fetch(:user, {})
    end
end
