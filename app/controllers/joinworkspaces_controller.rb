class JoinworkspacesController < ApplicationController
    def edit 
      
    end
    def create
        email=params[:email]
        @wspace=MWorkspace.find_by(workspace_name: params[:wname])
    
        @user=MUser.find_by(email: email)
        if @user
            @relationship=TRelationship.where("workspace_id=? and user_id=?",@wspace.id,@user.id)
            if @relationship
                flash.now[:danger]='このワークスペースに既に参加しています.'
                render "edit"
            else
                @t_relationship=TRelationship.new
                @t_relationship.workspace_id=@wspace.id
                @t_relationship.user_id = @user.id
                if @user && @user.authenticate(params[:session][:password]) && params[:session][:name]== user[:name]
                    @t_relationship.save
                    redirect_to root_url
                else
                    flash.now[:danger]='ユーザー名またはパスワードが間違っている。'
                    render "edit"
                end
            end
        else
            @m_user=MUser.new
            @m_user.name=params[:session][:name]
            @m_user.email=email
            @m_user.password=params[:session][:password]
            if @m_user.save
                @user=MUser.find_by(email: email)
                @t_relationship=TRelationship.new
                @t_relationship.workspace_id=@wspace.id
                @t_relationship.user_id=@user.id
                @t_relationship.msg_count=0
                @t_relationship.cha_id=0
                @t_relationship.isdeactivated=false
                @t_relationship.save
                redirect_to root_url
            else
                flash.now[:danger]='ユーザー名またはパスワードが間違っている。'
                render "edit"
            end
        end      
    end
end
