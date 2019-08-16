class MUsersController < ApplicationController
  def new
    @m_user = MUser.new
  end

  def create
    @m_user = MUser.new(user_params)
    name = params[:m_user][:name]
    email = params[:m_user][:email]
    password = params[:m_user][:password]
    password_confirmation = params[:m_user][:password_confirmation]
    if name == "" || name.nil? && email == "" || email.nil? && password == "" || password.nil? && password_confirmation == "" || password_confirmation.nil?
      flash[:danger] = "名前、メールアドレス、パスワードと確認パスワードは空白にできません。"
      render 'new'
    elsif email == "" || email.nil?
      flash[:danger] = "メールアドレスは空白にできません。"
      render 'new'
    elsif password == "" || password.nil?
      flash[:danger] = "パスワードは空白にできません。"
      render 'new'
    elsif password_confirmation == "" || password_confirmation.nil?
      flash[:danger] = "確認パスワードは空白にできません。"
      render 'new'
    elsif password != password_confirmation
      flash[:danger] = "パスワードと確認パスワードが一致しない"
      render 'new'
    else
      if @m_user.save==false
        @user=MUser.find_by(email: @m_user[:email])
        if @user
          user=@user
          signup user
          flash[:danger] = " "
          redirect_to createworkspace_url
        else
          render 'new'
        end
      else
        signup @m_user
        flash[:danger] = " "
        redirect_to createworkspace_url
      end
    end
  end

  private

    def user_params
      params.require(:m_user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end