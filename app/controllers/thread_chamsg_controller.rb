class ThreadChamsgController < ApplicationController
  def thread_chamsg 
    chamsgclickid=TChamsg.find_by(id:params[:clickchamsgid])
    logchaclickmsgid chamsgclickid

    @chaandunread=MCha.select("m_chas.id,name,t_relationships.msg_count")
                             .joins("join t_relationships on m_chas.id=t_relationships.cha_id").
                              where("t_relationships.workspace_id=?",@wid)
	  @chaandunread.each { |a|
        @totalchaunread=@totalchaunread + a.msg_count
        }

    @chaMsg=MUser.select("name,msg,t_chamsgs.id,t_chamsgs.created_at").joins("join t_chamsgs on t_chamsgs.sender_id=m_users.id")
    .where("t_chamsgs.cha_id=? and t_chamsgs.id=?",session[:cha_id],params[:clickchamsgid])

    @threadmsgoutput=MUser.select("h_cha_threads.chamsg_id,h_cha_threads.chathread_msg,h_cha_threads.created_at,m_users.name")
                  .joins("join h_cha_threads on m_users.id=h_cha_threads.user_id").where("h_cha_threads.chamsg_id=?", params[:clickchamsgid]) 

    @user=MUser.select("distinct name,m_users.id").joins("join t_relationships on m_users.id=t_relationships.user_id").
                  where("t_relationships.isdeactivated=0 and t_relationships.workspace_id=? and t_relationships.user_id!=?",session[:workspace_id],session[:user_id])  
    @cha=MCha.where("workspace_id=?",session[:workspace_id])
               
    @cha_member_list=MUser.select("name,t_relationships.id").joins("join t_relationships on m_users.id=t_relationships.user_id")
                   .where("t_relationships.isdeactivated=0 and t_relationships.workspace_id=? and t_relationships.cha_id=?",session[:workspace_id],session[:cha_id])
    @user_list=MUser.find_by_sql("select * from m_users")
               
    @cha_member_count=MUser.select("count(*) as usercount").joins("join t_relationships on m_users.id=t_relationships.user_id")
                   .where("t_relationships.isdeactivated=0 and t_relationships.workspace_id=? and t_relationships.cha_id=?",session[:workspace_id],session[:cha_id])
 end
 
 def thread_msgsend
  
 end
 def create
   @chathreadmsg=HChaThread.new
   @chathreadmsg.chathread_msg=params[:session][:sendmsg]
   @chathreadmsg.chamsg_id=session[:chamsgclick_id]
   @chathreadmsg.user_id=session[:user_id]
   @chathreadmsg.save
 end

private
def chathreadmsg_params
    params.require(:h_cha_thread).permit(:sendmsg)
end
end
