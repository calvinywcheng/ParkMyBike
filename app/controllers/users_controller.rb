class UsersController < ApplicationController

  before_filter :save_login_state, :only => [:new, :create]

  def new
      #Signup Form
      @user = User.new
  end

   def create
      @user = User.new(user_params)
      if @user.save
        flash[:notice] = "You Signed up successfully"
        redirect_to sessions_login_path
      else
        render 'new'
      end
    end

  private

    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end

end