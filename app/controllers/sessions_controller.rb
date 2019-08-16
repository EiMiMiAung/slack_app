class SessionsController < ApplicationController
  def new
  end
  def create
    user = MUser.find_by(email: params[:session][:email].downcase)
    space = MWorkspace.find_by(workspace_name: params[:session][:wname])
	  if space && user && user.authenticate(params[:session][:password]) && (space[:user_id] == user[:id]) 
      log_out
      admin user
      log space
      log_in user
      redirect_to msgsendandrec_path
     
    elsif space && user && (user.authenticate(params[:session][:password])) && TRelationship.where("user_id=? and workspace_id=?", user[:id], space[:id])[0]!=nil   
      log_out
      log space
      log_in user
      redirect_to msgsendandrec_path
      # Log the user in and redirect to the user's show page.
    else
      # Create an error message.
      flash.now[:danger] = 'メールアドレス・パスワード・ワークスペースが無効です'
      render 'new'
  end
end

def destroy
  log_out
  redirect_to root_url
end

def log_out
  session.delete(:admin_id)
  session.delete(:user_id)
  session.delete(:user_name)
  session.delete(:workspace_id)
  session.delete(:workspace_name)
  session.delete(:cha_id)
  session.delete(:cha_name)
end
end
