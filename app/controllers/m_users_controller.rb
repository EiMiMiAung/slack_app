class MUsersController < ApplicationController
  def new
    @m_user = MUser.new
  end

  def create
    @@m_user = MUser.new(user_params)
    if @@m_user.save==false
      @@user=MUser.find_by(email: @@m_user[:email])
      user=@@user
      signup user
      redirect_to createworkspace_url
    elsif @@m_user.save
      user=MUser.find_by(email: @@m_user[:email])
      signup user
      redirect_to createworkspace_url
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:m_user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
