class StarMessagesController < ApplicationController
  def new
    menu
    @dstarmessage = MUser.select("m_users.name,t_dmsgs.msg,t_dmsgs.id,t_dmsgs.created_at")
    .joins("join t_dmsgs on t_dmsgs.sender_id=m_users.id")
    .joins("join h_dstarmsgs on h_dstarmsgs.dmsg_id=t_dmsgs.id")
    .where("h_dstarmsgs.user_id=?",session[:user_id])
    @channelstarmessage = MUser.select("m_users.name as username,h_chastarmsgs.chamsg_id,m_chas.name as chaname,t_chamsgs.msg,t_chamsgs.id, t_chamsgs.created_at")
    .joins("join t_chamsgs on t_chamsgs.sender_id=m_users.id")
    .joins("join h_chastarmsgs on h_chastarmsgs.chamsg_id=t_chamsgs.id")
    .joins("join m_chas on m_chas.id=t_chamsgs.cha_id")
    .where("h_chastarmsgs.user_id=?",session[:user_id])
    
  end
  def directstarmsgdestroy
    HDstarmsg.find_by(dmsg_id:params[:starmsgid]).destroy
    redirect_to starmessage_url
  end

  def channelstarmsgdestroy
    HChastarmsg.find_by(chamsg_id:params[:starmsgid]).destroy
    redirect_to starmessage_url
  end
end
