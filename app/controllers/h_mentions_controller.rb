class HMentionsController < ApplicationController
  def show
    menu
    @mention = MUser.select("m_users.name,t_chamsgs.msg,h_mentions.created_at,m_chas.name as cha_name")
    .joins("join t_chamsgs on t_chamsgs.sender_id=m_users.id")
    .joins("join h_mentions on h_mentions.chamsg_id=t_chamsgs.id")
    .joins("join m_chas on m_chas.id=t_chamsgs.cha_id")
    .where("h_mentions.user_id=?",session[:user_id])
  end
end
  
