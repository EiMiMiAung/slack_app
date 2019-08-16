class AllUnreadController < ApplicationController
  def allunread
    menu
    @dirUnreadMsg=MUser.select("m_users.name,t_dmsgs.msg,t_dmsgs.created_at")
    .joins("join t_dmsgs on t_dmsgs.sender_id=m_users.id")
    .where("t_dmsgs.isread=false and t_dmsgs.receiver_id=?",session[:user_id])

    @arrChaunreadmsg=[]
    @count=TRelationship.select("msg_count,cha_id").where("workspace_id=? and user_id=? and msg_count!=0 and isdeactivated=false
    ",session[:workspace_id],session[:user_id])
    for chaid in @count
      @chaUnread=MUser.select("m_chas.name as cha_name,m_users.name as user_name,msg,t_chamsgs.created_at,t_chamsgs.id")
      .joins("join t_chamsgs on t_chamsgs.sender_id=m_users.id")
      .joins("join m_chas on m_chas.id=t_chamsgs.cha_id")
      .where("t_chamsgs.cha_id=? and t_chamsgs.sender_id!=?",chaid.cha_id,session[:user_id])
      .order("t_chamsgs.id DESC").limit(chaid.msg_count)
      if @chaUnread
        @chaUnreadMsg=@chaUnread.sort_by(&:id)
      end
      for array in @chaUnreadMsg
        @arrChaunreadmsg << array
      end
    end   
  end
  def allread
    TRelationship.where("workspace_id=? and user_id=? ",session[:workspace_id],session[:user_id]).update_all(msg_count: 0)
    TDmsg.where("workspace_id=? and receiver_id=?",session[:workspace_id],session[:user_id]).update_all(isread: true)
    redirect_to allunread_path
  end
end


    