class HMentionsController < ApplicationController
    def show
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
      
      @mention = MUser.select("name,msg,m_users.created_at").
      joins("join t_chamsgs on t_chamsgs.sender_id=m_users.id 
      join h_mentions on h_mentions.chamsg_id=t_chamsgs.id")
      .where("h_mentions.user_id=?",session[:user_id])
    end
  end
  
