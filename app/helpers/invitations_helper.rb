module InvitationsHelper
   
    def log_space(space)
        session[:workspace_name] = space.workspace_name
        session[:workspace_id] = space.id
      end
end
