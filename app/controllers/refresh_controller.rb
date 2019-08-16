class RefreshController < ApplicationController
  def new    
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
    
    @dirdate=TDmsg.select("distinct DATE(created_at) as date")
    @dirmsgidstar=HDstarmsg.select("*").where("user_id=?",session[:user_id])

    @directmsgoutput=TDmsg.select("t_dmsgs.msg,t_dmsgs.created_at,m_users.name,t_dmsgs.id,t_dmsgs.sender_id")
               .joins("inner join m_users on t_dmsgs.sender_id=m_users.id")
               .where("t_dmsgs.workspace_id=? and ((t_dmsgs.sender_id=? and t_dmsgs.receiver_id=?) or (t_dmsgs.receiver_id=? and t_dmsgs.sender_id=?))",session[:workspace_id],session[:user_id],session[:clickuser_id],session[:user_id],session[:clickuser_id])

    @arrDirThread = []
    for dirthread in @directmsgoutput
      @dirmsgthread=HDthread.select("count(h_dthreads.dmsg_id) as count, h_dthreads.dmsg_id")
                 .joins("join t_dmsgs on h_dthreads.dmsg_id=t_dmsgs.id")
                 .where("h_dthreads.dmsg_id=?",dirthread.id)
                 .group("h_dthreads.dmsg_id")
      for array in @dirmsgthread
        @arrDirThread << array
      end
    end
    TDmsg.where("workspace_id=? and sender_id=?",session[:workspace_id],session[:clickuser_id]).update_all(isread: true)
    TRelationship.where("cha_id=? and user_id=? ",session[:cha_id],session[:user_id]).update_all(msg_count: 0)

    @chadate=TChamsg.select("distinct DATE(created_at) as date")
    @chamsgidstar=HChastarmsg.select("*").where("user_id=?",session[:user_id])

    @chamsgoutput=MUser.select("t_chamsgs.msg,t_chamsgs.created_at,m_users.name,t_chamsgs.id,t_chamsgs.sender_id")
              .joins("join t_chamsgs on m_users.id=t_chamsgs.sender_id")
              .where("t_chamsgs.cha_id=? and t_chamsgs.workspace_id=?",session[:cha_id],session[:workspace_id]) 
                
    @arrChaThread = []
    for chathread in @chamsgoutput
      @chamsgthread=HChaThread.select("count(h_cha_threads.chamsg_id) as count, h_cha_threads.chamsg_id")
                .joins("join t_chamsgs on h_cha_threads.chamsg_id=t_chamsgs.id")
                .where("h_cha_threads.chamsg_id=?",chathread.id)
                .group("h_cha_threads.chamsg_id")
      for array in @chamsgthread
        @arrChaThread << array
      end
    end

    respond_to do |format|
      format.js
    end
  end
end
