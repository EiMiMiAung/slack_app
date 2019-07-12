class DirectMsgconController < ApplicationController
  def direct_msgcon 
	directclick=MUser.find_by(id:params[:clickuserid])
     logdirectclick directclick
     @directmsgoutput=TDmsg.select("t_dmsgs.msg,t_dmsgs.created_at,m_users.name,t_dmsgs.id,t_dmsgs.sender_id")
     .joins("inner join m_users on t_dmsgs.sender_id=m_users.id")
     .where("t_dmsgs.workspace_id=? and ((t_dmsgs.sender_id=? and t_dmsgs.receiver_id=?) || (t_dmsgs.receiver_id=? and t_dmsgs.sender_id=?))",session[:workspace_id],session[:user_id],params[:clickuserid],session[:user_id],params[:clickuserid])

    @array = []
    for dirthread in @directmsgoutput
       @dirmsgthread=HDthread.select("count(h_dthreads.dmsg_id) as count, h_dthreads.dmsg_id").
                     joins("join t_dmsgs on h_dthreads.dmsg_id=t_dmsgs.id").where("h_dthreads.dmsg_id=?",dirthread.id)
        for array in @dirmsgthread
          @array << array
        end
    end
    
     TDmsg.where("workspace_id=? and sender_id=?",session[:workspace_id],session[:clickuser_id]).update_all(isread: 1)
     @star="star"
     @unstar="unstar"
     @thread="thread"
     @dirmsgidstar=HDstarmsg.select("*")
     @chaandunread=MCha.select("m_chas.id,name,t_relationships.msg_count")
    .joins("join t_relationships on m_chas.id=t_relationships.cha_id").
     where("t_relationships.workspace_id=?",session[:workspace_id])
     @user=MUser.select("distinct name,m_users.id").joins("join t_relationships on m_users.id=t_relationships.user_id").
    where("t_relationships.isdeactivated=0 and t_relationships.workspace_id=? and t_relationships.user_id!=?",session[:workspace_id],session[:user_id])
  
    @dirdate=TDmsg.select("distinct DATE(created_at) as date")
  

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
    
  end
	def unstar
     HDstarmsg.find_by(user_id: session[:user_id],dmsg_id: params[:starclickdirmsgid]).destroy
     redirect_back(fallback_location:directmsg_path)
	end
	def star
      @dirstarmsg=HDstarmsg.new
      @dirstarmsg.dmsg_id=params[:starclickdirmsgid]
      @dirstarmsg.user_id=session[:user_id]
      @dirstarmsg.save
      redirect_back(fallback_location:directmsg_path)
  end

  def delete
    TDmsg.find_by(id: params[:delclickdmsgid]).destroy
    @dmsgid=HDstarmsg.find_by(dmsg_id: params[:delclickdmsgid])
    redirect_back(fallback_location:directmsg_path)
  end

  def direct_msgsend
  end
  def create
    @directmsg = TDmsg.new
    @directmsg.sender_id=session[:user_id]
    @directmsg.receiver_id=session[:clickuser_id]
    @directmsg.msg=params[:session][:sendmsgdir]
    @directmsg.isread="0"
    @directmsg.workspace_id=session[:workspace_id]
    @directmsg.save
    redirect_back(fallback_location:directmsg_path)
  end

private
 def directmsg_params
     params.require(:t_d_msg).permit(:sendmsgdir)
 end
end