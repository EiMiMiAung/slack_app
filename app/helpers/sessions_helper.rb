module SessionsHelper
  def admin(user)
    session[:admin_id]=user.id
  end
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

  def menu
    @totalchaunread=0
    @arrChamsgcount = []
    @chaname=MCha.select("m_chas.name,m_chas.id,m_chas.isprivate")
    .joins("join t_relationships on m_chas.id=t_relationships.cha_id")
    .where("t_relationships.workspace_id=? and t_relationships.user_id=? and isdeactivated=false",session[:workspace_id],session[:user_id] )
    for a in @chaname
      @count=TRelationship.select("msg_count,cha_id").where("cha_id=? and user_id=?",a.id,session[:user_id])
      for array in @count
        @arrChamsgcount << array
        @totalchaunread=@totalchaunread+array.msg_count
      end
    end
    
    @user=MUser.select("distinct m_users.name,m_users.id")
    .joins("join t_relationships on m_users.id=t_relationships.user_id")
    .where("t_relationships.workspace_id=? and t_relationships.user_id!=?",session[:workspace_id],session[:user_id]) 
    @dirunread=TDmsg.select("*").where("isread=false and receiver_id=? and workspace_id=?",session[:user_id],session[:workspace_id])
    @totalunread=(@totalchaunread + @dirunread.size).to_s
     
    @dirunreadarray = []
    for userid in @user
      @diruserisread=TDmsg.select("count(id) as count,sender_id")
      .where("receiver_id=? and sender_id=? and workspace_id=? and isread=false",session[:user_id],userid.id,session[:workspace_id])
      .group("sender_id")
      for array in @diruserisread
        @dirunreadarray << array
      end 
    end
  end
end
