class WorkspacesController < ApplicationController
  def new
    @m_workspace = MWorkspace.new
  end
  
  def createspace
    @m_workspace = MWorkspace.new
  end

  def create
    @m_workspace = MWorkspace.new(workspace_params)
    @workspace=MWorkspace.find_by(workspace_name: @m_workspace[:workspacename])
    if @m_workspace.save
      redirect_to main_url
    else
      render 'new'
    end
   end

  def creatework
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
      @relationship.workspace_id=workspace[:id]
      if @channel.save
      channel=MCha.where("workspace_id=? and name=?", workspace[:id], channel_name)
      @relationship.cha_id=channel[0][:id]
      @relationship.isdeactivated="0"
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

  private

  def workspace_params
    params.require(:m_workspace).permit(:workspace_name)
  end

  private

  def channel_params
    params.require(:m_cha).permit(:name)
  end
end