module SessionsHelper
    def log_in(user)
        session[:user_name] = user.name
        session[:user_id]=user.id
    end
    def log(space)
      session[:workspace_name] = space.workspace_name
      session[:workspace_id] = space.id
    end
    def logchaclick(chaclick)
      session[:cha_id] = chaclick.id
      session[:cha_name] = chaclick.name
    end
    def logdirectclick(directclick)
      session[:clickuser_id] = directclick.id
      session[:clickuser_name] = directclick.name
    end
	def logchaclickmsgid(chamsgclickid)
      session[:chamsgclick_id]=chamsgclickid.id
    end   

    def logdirclickmsgid(dirmsgclickid)
      session[:dirmsgclick_id]=dirmsgclickid.id
    end  
end
