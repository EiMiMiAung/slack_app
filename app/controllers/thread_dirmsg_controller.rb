class ThreadDirmsgController < ApplicationController
  def thread_dirmsg 
    dirmsgclickid=TDmsg.find_by(id:params[:clickdirmsgid])
    logdirclickmsgid dirmsgclickid
    @dirMsg=MUser.select("name,msg,t_dmsgs.id,t_dmsgs.created_at").joins("join t_dmsgs on t_dmsgs.sender_id=m_users.id")
    .where("t_dmsgs.id=?",params[:clickdirmsgid])

    @dirthreadmsgoutput=MUser.select("h_dthreads.thread_msg,h_dthreads.dmsg_id,h_dthreads.created_at,m_users.name")
                  .joins("join h_dthreads on m_users.id=h_dthreads.user_id").where("h_dthreads.dmsg_id=?", params[:clickdirmsgid]) 
    @star="star"
    @thread="thread"

    @chaandunread=MCha.select("m_chas.id,name,t_relationships.msg_count")
                             .joins("join t_relationships on m_chas.id=t_relationships.cha_id").
                              where("t_relationships.workspace_id=?",@wid)
    @user=MUser.select("distinct name,m_users.id").joins("join t_relationships on m_users.id=t_relationships.user_id").
    where("t_relationships.isdeactivated=0 and t_relationships.workspace_id=? and t_relationships.user_id!=?",session[:workspace_id],session[:user_id])
 end
 def thread_msgsend
  
 end
 def create
   @chathreadmsg=HDthread.new
   @chathreadmsg.thread_msg=params[:session][:sendmsg]
   @chathreadmsg.dmsg_id=session[:dirmsgclick_id]
   @chathreadmsg.user_id=session[:user_id]
   @chathreadmsg.save
 end

private
def dirthreadmsg_params
    params.require(:h_dthread).permit(:sendmsg)
end
end
