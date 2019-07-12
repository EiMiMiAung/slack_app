class ChaMsgconController < ApplicationController
  def cha_msgcon 
    @usernames=MUser.select("name,m_users.id").joins("join t_relationships on m_users.id=t_relationships.user_id").where("t_relationships.workspace_id=? and t_relationships.cha_id=?", session[:workspace_id],session[:cha_id])
    chaclick=MCha.find_by(id:params[:clickchaid])
    logchaclick chaclick
	  @chaclick=chaclick
    @chaid=chaclick.id
	@users=MUser.select("*")
	@chamsgoutput=MUser.select("t_chamsgs.msg,t_chamsgs.created_at,m_users.name,t_chamsgs.id")
                .joins("join t_chamsgs on m_users.id=t_chamsgs.sender_id").where("t_chamsgs.cha_id=?",params[:clickchaid]) 
  
  @arrayt = []
  for chathread in @chamsgoutput
    @chamsgthread=HChaThread.select("count(h_cha_threads.chamsg_id) as count, h_cha_threads.chamsg_id").
                  joins("join t_chamsgs on h_cha_threads.chamsg_id=t_chamsgs.id").
                  where("h_cha_threads.chamsg_id=?",chathread.id)
     for array in @chamsgthread
       @arrayt << array
     end
  end		
	@star="star"
	@unstar="unstar"
  @thread="thread"
  @delete="delete"
	@chamsgidstar=HChastarmsg.select("*")
	TRelationship.where("cha_id=? and user_id=? ",params[:clickchaid],session[:user_id]).update_all(msg_count: 0)

    @cha_member_list=MUser.select("name,t_relationships.id").joins("join t_relationships on m_users.id=t_relationships.user_id")
    .where("t_relationships.isdeactivated=0 and t_relationships.workspace_id=? and t_relationships.cha_id=?",session[:workspace_id],session[:cha_id])
    @user_list=MUser.find_by_sql("select * from m_users")

    @cha_member_count=MUser.select("count(*) as usercount").joins("join t_relationships on m_users.id=t_relationships.user_id")
    .where("t_relationships.isdeactivated=0 and t_relationships.workspace_id=? and t_relationships.cha_id=?",session[:workspace_id],session[:cha_id])
    
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
    HChastarmsg.find_by(user_id: session[:user_id],chamsg_id: params[:starclickchamsgid]).destroy
    redirect_back(fallback_location:channelmsg_path)
  end
  
  def star
    @chastarmsg=HChastarmsg.new
    @chastarmsg.chamsg_id=params[:starclickchamsgid]
    @chastarmsg.user_id=session[:user_id]
    @chastarmsg.save
    redirect_back(fallback_location:channelmsg_path)
  end

  def delete
    TChamsg.find_by(id: params[:delclickchamsgid]).destroy
    @chamsgid=HChastarmsg.find_by(chamsg_id: params[:delclickchamsgid])
    redirect_back(fallback_location:channelmsg_path)
  end
  
  def cha_msgsend
    
  end
  
  def removemember
    @trid=TRelationship.find(params[:user_id])
    @trid.isdeactivated=true
    @trid.save
    redirect_back(fallback_location:channelmsg_path)
  end

  def create
    mention_name = params[:session][:memtion_name]
    mention_name[0] = ''
    @mention_u = MUser.find_by(name: mention_name)
    
    @chamsg=TChamsg.new
    @chamsg.msg=params[:session][:sendmsg]
    @chamsg.sender_id=session[:user_id]
    @chamsg.cha_id=session[:cha_id]
    @chamsg.save
    maxid=TChamsg.maximum('id')
      if @mention_u   
        @mention=HMention.new
        @mention.user_id = @mention_u.id
        @mention.chamsg_id= maxid
        @mention.save
      end
    @rs=TRelationship.where("cha_id=? and user_id!=? and workspace_id=?",@chaid,session[:user_id],session[:workspace_id])
    @rs.each { |v|
        TRelationship.where(id: v.id).update_all(msg_count: v.msg_count+1)
     }
     redirect_back(fallback_location:directmsg_path)
  end

  def insertfun
    @enum_value = TRelationship.create(user_id: params[:user_id], workspace_id: session[:workspace_id], cha_id: session[:cha_id], isdeactivated: false, msg_count:0)
    redirect_to msgsendandrec_path
  end
  
  def mentionmember
    @username=MUser.find_by_sql("select name,m_users.id from m_users 
    join t_relationships on m_users.id=t_relationships.user_id where t_relationships.workspace_id=?
    and t_relationships.cha_id=?",session[:workspace_id],session[:cha_id])
  end

private
 def channelmsg_params
     params.require(:t_cha_msg).permit(:sendmsg)
 end

end
