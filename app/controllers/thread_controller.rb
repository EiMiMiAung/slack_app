class ThreadController < ApplicationController
  def thread
    menu
    
    @directMsg=MUser.select("t_dmsgs.id,m_users.name,t_dmsgs.msg,t_dmsgs.created_at")
    .joins("join t_dmsgs on t_dmsgs.sender_id=m_users.id")
    .joins("join h_dthreads on h_dthreads.dmsg_id=t_dmsgs.id")
    .where("(t_dmsgs.sender_id=? or t_dmsgs.receiver_id=? or h_dthreads.user_id=?) and t_dmsgs.workspace_id=?",session[:user_id],session[:user_id],session[:user_id],session[:workspace_id])

    @directThreadMsg=MUser.select("h_dthreads.dmsg_id,m_users.name,h_dthreads.thread_msg,h_dthreads.created_at")
    .joins("join h_dthreads on h_dthreads.user_id=m_users.id")
    .joins("join t_dmsgs on t_dmsgs.id=h_dthreads.dmsg_id")
    .where("(t_dmsgs.sender_id=? or t_dmsgs.receiver_id=?) and t_dmsgs.workspace_id=?",session[:user_id],session[:user_id],session[:workspace_id])

    @chaMsg=MUser.select("t_chamsgs.id,m_chas.name as cha_name,m_users.name as user_name,msg,t_chamsgs.created_at")
    .joins("join t_chamsgs on t_chamsgs.sender_id=m_users.id")
    .joins("join h_cha_threads on h_cha_threads.chamsg_id=t_chamsgs.id")
    .joins("join m_chas on m_chas.id=t_chamsgs.cha_id")
    .where("(t_chamsgs.sender_id=? or h_cha_threads.user_id=?) and m_chas.workspace_id=?",session[:user_id],session[:user_id],session[:workspace_id])

    @chaThreadMsg=MUser.select("h_cha_threads.chamsg_id,m_users.name,h_cha_threads.chathread_msg,h_cha_threads.created_at")
    .joins("join h_cha_threads on h_cha_threads.user_id=m_users.id")
    .joins("join t_chamsgs on t_chamsgs.id=h_cha_threads.chamsg_id")
    .where("(h_cha_threads.user_id=? or t_chamsgs.sender_id=?) and t_chamsgs.workspace_id=?",session[:user_id],session[:user_id],session[:workspace_id])
    
  end
end
