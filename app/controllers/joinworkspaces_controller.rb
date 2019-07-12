class JoinworkspacesController < ApplicationController
    def edit 
      
    end
    def create
        email=params[:email]
    if MUser.find_by(email: email)
        @user=MUser.find_by(email: email)
            user=@user
        @t_relationship=TRelationship.new
        @t_relationship.workspace_id=session[:workspace_id] 
        @t_relationship.user_id = user[:id]
        if user && user.authenticate(params[:session][:password]) && params[:session][:name]== user[:name]
             @t_relationship.save
            redirect_to root_url
        else
            render "edit"
        end
    else
        @m_user=MUser.new
        @m_user.name=params[:session][:name]
        @m_user.email=email
        @m_user.password=params[:session][:password]
        @m_user.save
        user=MUser.find_by(email: email)
        @t_relationship=TRelationship.new
        @t_relationship.workspace_id=session[:workspace_id] 
       @t_relationship.user_id=user.id
       @t_relationship.save
       redirect_to root_url
    end
        
    end
end
