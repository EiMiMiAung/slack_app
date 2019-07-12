class InvitationsController < ApplicationController
  def invitemember
    @m_user = MUser.new
  end
  def create
   @user1=MUser.find_by(email: params[:invitations][:email1].downcase)
   @user2=MUser.find_by(email: params[:invitations][:email2].downcase)
   @user3=MUser.find_by(email: params[:invitations][:email3].downcase)
   @array=[@user1,@user2,@user3]
   for user in @array
    @user=user
    if @user
                            wspace=session[:workspace_id]
                                      if (TRelationship.where("user_id=? and workspace_id=?", user[:id], wspace)[0])==nil
                                      @user.email = params[:invitations][:email1].downcase
                                      @user. create_invitation_digest
                                      UserMailer.invite_members(@user,session[:workspace_name]).deliver_now
                                      end
    
    else
      wspace=session[:workspace_id]
      @user= MUser.new()
      @user.email = params[:invitations][:email1].downcase
      @user. create_invitation_digest
                      if @user.email!=""
                      UserMailer.invite_members(@user,session[:workspace_name]).deliver_now
                       end
    end
  end
  redirect_to msgsendandrec_path
end
end