class ThreadChamsgController < ApplicationController
  def thread_chamsg 
    chamsgclickid=TChamsg.find_by(id:params[:clickchamsgid])
    logchaclickmsgid chamsgclickid
    @chaMsg=MUser.select("m_users.name,t_chamsgs.msg,t_chamsgs.id,t_chamsgs.created_at")
    .joins("join t_chamsgs on t_chamsgs.sender_id=m_users.id")
    .where("t_chamsgs.cha_id=? and t_chamsgs.id=?",session[:cha_id],params[:clickchamsgid])

    @threadmsgoutput=MUser.select("h_cha_threads.chamsg_id,h_cha_threads.chathread_msg,h_cha_threads.created_at,m_users.name")
    .joins("join h_cha_threads on m_users.id=h_cha_threads.user_id")
    .where("h_cha_threads.chamsg_id=?", params[:clickchamsgid]) 
           
    menu
  end
  def create
    @chathreadmsg=HChaThread.new
    @chathreadmsg.chathread_msg=params[:session][:sendmsg]
    @chathreadmsg.chamsg_id=session[:chamsgclick_id]
    @chathreadmsg.user_id=session[:user_id]
    @chathreadmsg.save
    redirect_back(fallback_location:threadmsg_path)
  end

  private
  def chathreadmsg_params
    params.require(:h_cha_thread).permit(:sendmsg)
  end
end
