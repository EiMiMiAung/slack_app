class ThreadDirmsgController < ApplicationController
  def thread_dirmsg 
    dirmsgclickid=TDmsg.find_by(id:params[:clickdirmsgid])
    logdirclickmsgid dirmsgclickid
    @dirMsg=MUser.select("m_users.name,t_dmsgs.msg,t_dmsgs.id,t_dmsgs.created_at")
    .joins("join t_dmsgs on t_dmsgs.sender_id=m_users.id")
    .where("t_dmsgs.id=?",params[:clickdirmsgid])

    @dirthreadmsgoutput=MUser.select("h_dthreads.thread_msg,h_dthreads.dmsg_id,h_dthreads.created_at,m_users.name")
    .joins("join h_dthreads on m_users.id=h_dthreads.user_id")
    .where("h_dthreads.dmsg_id=?", params[:clickdirmsgid]) 
    
    menu
  end
  def create
    @chathreadmsg=HDthread.new
    @chathreadmsg.thread_msg=params[:session][:sendmsg]
    @chathreadmsg.dmsg_id=session[:dirmsgclick_id]
    @chathreadmsg.user_id=session[:user_id]
    @chathreadmsg.save
    redirect_back(fallback_location:dirthreadmsg_path)
  end

  private
  def dirthreadmsg_params
    params.require(:h_dthread).permit(:sendmsg)
  end
end
