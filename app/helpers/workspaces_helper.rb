module WorkspacesHelper
    def workspacecreate(workspace,channel)
        session[:workspace_id]=workspace.id
        session[:workspace_name]=workspace.workspace_name
        session[:channel_id]=channel[:id]
    end
end
