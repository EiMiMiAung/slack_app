class ThreadController < ApplicationController
  def thread
    @cha=MCha.where("workspace_id=?",session[:workspace_id])
    @wid=session[:workspace_id] 
    @totalchaunread=0
    @array = []
    @chaname=MCha.select("name,id").where("workspace_id=?",@wid)
    for a in @chaname
        @count=TRelationship.select(" msg_count,cha_id").where("cha_id=? and user_id=?",a.id,session[:user_id])
        for array in @count
          @array << array
        end 
    end
   
    @totalcount=TRelationship.select("sum(msg_count) as value").where("workspace_id=? and user_id=?",@wid,session[:user_id])
    @totalcount.each { |a|
       @totalchaunread=a.value
  }
    
      @arrayd = []
      @user=MUser.select("distinct name,m_users.id").joins("join t_relationships on m_users.id=t_relationships.user_id").
      where("t_relationships.isdeactivated=0 and t_relationships.workspace_id=? and t_relationships.user_id!=?",session[:workspace_id],session[:user_id]) 
      for a in @user
          @diruserisread=TDmsg.select("count(id) as value,sender_id").where("receiver_id=? and sender_id=? and workspace_id=? and isread=0",session[:user_id],a.id,session[:workspace_id])
          for array in @diruserisread
            @arrayd << array
          end 
      end
      @dirunread=TDmsg.select("*").where("receiver_id=? and workspace_id=? and isread=0",session[:user_id],session[:workspace_id])
     if @totalchaunread
      @totalunread=@dirunread.size + @totalchaunread
     end
    @chaandunread=MCha.select("m_chas.id,name,t_relationships.msg_count")
    .joins("join t_relationships on m_chas.id=t_relationships.cha_id").
     where("t_relationships.workspace_id=?",session[:workspace_id])
    
    @directMsg=MUser.select("distinct t_dmsgs.id,name,msg,t_dmsgs.created_at")
    .joins("join t_dmsgs on t_dmsgs.sender_id=m_users.id join h_d_threads on h_d_threads.dmsg_id=t_dmsgs.id")
    .where("sender_id=? or h_d_threads.user_id=? and t_dmsgs.workspace_id=?",session[:user_id],session[:user_id],session[:workspace_id])

    @directThreadMsg=MUser.select("h_d_threads.dmsg_id,name,thread_msg,h_d_threads.created_at")
    .joins("join h_d_threads on h_d_threads.user_id=m_users.id join t_dmsgs on t_dmsgs.id=h_d_threads.dmsg_id")
    .where("t_dmsgs.sender_id=? or t_dmsgs.receiver_id=?",session[:user_id],session[:user_id])

    @chaMsg=MUser.select("distinct t_chamsgs.id,m_chas.name as cha_name,m_users.name as user_name,msg,
    t_chamsgs.created_at").joins("join t_chamsgs on sender_id=m_users.id 
    join h_cha_threads on h_cha_threads.chamsg_id=t_chamsgs.id 
    join m_chas on m_chas.id=t_chamsgs.cha_id")
    .where("sender_id=? or h_cha_threads.user_id=? and m_chas.workspace_id=?",session[:user_id],session[:user_id],session[:workspace_id])

    @chaThreadMsg=MUser.select("h_cha_threads.chamsg_id,name,chathread_msg,h_cha_threads.created_at")
    .joins("join h_cha_threads on h_cha_threads.user_id=m_users.id 
    join t_chamsgs on t_chamsgs.id=chamsg_id")
    .where("h_cha_threads.user_id=? or t_chamsgs.sender_id=?",session[:user_id],session[:user_id])
    
  end
end
