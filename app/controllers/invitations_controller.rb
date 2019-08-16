class InvitationsController < ApplicationController
  def invitemember
    menu
  end
  def create
    @array=[params[:invitations][:email1] , params[:invitations][:email2] , params[:invitations][:email3]]
    for e in @array
      @user=MUser.find_by(email: e)
      if @user
        wspace=session[:workspace_id]
        if (TRelationship.where("user_id=? and workspace_id=?", @user.id, wspace)[0])==nil
          UserMailer.invite_members(@user,session[:workspace_name]).deliver_now
          flash[:alert]= "Email has been sent to user"
        end
      else
        wspace=session[:workspace_id]
        @user= MUser.new()
        @user.email=e
        if @user.email!=""
          UserMailer.invite_members(@user,session[:workspace_name]).deliver_now
          flash[:alert]= "Email has been sent to user"
        end
      end                
    end
    redirect_to msgsendandrec_path
  end
end