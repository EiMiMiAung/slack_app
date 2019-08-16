class WorkspacesController < ApplicationController
  def new
    @m_workspace = MWorkspace.new
  end

  def creatework
    if params[:session][:workspace_name]!="" && params[:session][:name]!=""
      @workspacename=MWorkspace.find_by(workspace_name: params[:session][:workspace_name])
      if @workspacename != nil
        flash.now[:danger]='ワークスペース名は既に存在します。'
        render 'new'
      else
        @workspace = MWorkspace.new
        @channel = MCha.new
        @relationship = TRelationship.new
        @workspace.user_id = session[:user_id]
        @relationship.user_id = session[:user_id]
        @workspace.workspace_name = params[:session][:workspace_name]
        @channel.name = params[:session][:name]
        channel_name = params[:session][:name]
        if @workspace.save
          workspace = MWorkspace.find_by(workspace_name: @workspace[:workspace_name])
          @channel.workspace_id=workspace[:id]
          @channel.isprivate=false
          @relationship.workspace_id=workspace[:id]
          if @channel.save
            channel=MCha.where("workspace_id=? and name=?", workspace[:id], channel_name)
            @relationship.cha_id=channel[0][:id]
            @relationship.isdeactivated=false
            @relationship.msg_count=0
            if @relationship.save
              workspacecreate workspace,channel[0]
              redirect_to msgsendandrec_url
            else
              render 'new'
            end
          else
            render 'new'
          end
        else
          render  'new'
        end
      end
    elsif params[:session][:workspace_name]=="" && params[:session][:name]==""
      flash.now[:danger]='ワークスペース名とチャンネル名は空白にできません。'
      render 'new'
    elsif params[:session][:workspace_name]==""
      flash.now[:danger]='ワークスペース名は空白にできません。'
      render 'new'
    elsif params[:session][:name]==""
      flash.now[:danger]='チャンネル名は空白にできません。'
      render 'new'
    end
  end
end