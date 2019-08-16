require 'will_paginate/array'
class ChaMsgconController < ApplicationController
  def cha_msgcon 
    @usernames=MUser.select("m_users.name,m_users.id")
    .joins("join t_relationships on m_users.id=t_relationships.user_id")
    .where("t_relationships.user_id!=? and t_relationships.workspace_id=? and t_relationships.cha_id=? and t_relationships.isdeactivated=false", session[:user_id],session[:workspace_id],session[:cha_id])
    
    chaclick=MCha.find_by(id: params[:clickchaid])
    logchaclick chaclick
        
    @chamsgoutput=MUser.select("t_chamsgs.msg,t_chamsgs.created_at,m_users.name,t_chamsgs.id,t_chamsgs.sender_id")
    .joins("join t_chamsgs on m_users.id=t_chamsgs.sender_id")
    .where("t_chamsgs.cha_id=? and t_chamsgs.workspace_id=?",params[:clickchaid].to_i,session[:workspace_id]) 
      
    @arrChaThread = []
    for chathread in @chamsgoutput
      @chamsgthread=HChaThread.select("count(*) as count, h_cha_threads.chamsg_id")
      .joins("join t_chamsgs on h_cha_threads.chamsg_id=t_chamsgs.id")
      .where("h_cha_threads.chamsg_id=?",chathread.id)
      .group("h_cha_threads.chamsg_id")
      for array in @chamsgthread
        @arrChaThread << array
      end
    end		
     
    @chamsgidstar=HChastarmsg.select("*").where("user_id=?",session[:user_id])
    TRelationship.where("cha_id=? and user_id=? ",params[:clickchaid].to_i,session[:user_id]).update_all(msg_count: 0)

    @chadate=TChamsg.select("distinct DATE(created_at) as date")
    @insertarray = []
    @chaarray = []
      
    @updatelistpeople = MUser.select("m_users.name,t_relationships.user_id,t_relationships.id")
    .joins("join t_relationships on m_users.id=t_relationships.user_id")
    .where("t_relationships.workspace_id=? and t_relationships.cha_id=? and t_relationships.isdeactivated=true ",session[:workspace_id],session[:cha_id])
        
    @chauser = TRelationship.select("user_id").where("workspace_id=? and cha_id=?",session[:workspace_id],session[:cha_id])
    for array in @chauser
      @chaarray << array
    end 
    @insertlistpeople = MUser.select("distinct m_users.name,m_users.id")
    .joins("join t_relationships on m_users.id=t_relationships.user_id")
    .where("t_relationships.workspace_id=? and t_relationships.cha_id!=?",session[:workspace_id],session[:cha_id])
    for array in @insertlistpeople
      @insertarray << array
    end 

    @addmorepeople = MUser.select("distinct m_users.name,t_relationships.user_id,t_relationships.id,t_relationships.cha_id")
    .joins("join t_relationships on m_users.id=t_relationships.user_id")
    .where("(t_relationships.cha_id = ? or t_relationships.cha_id != ?) and t_relationships.workspace_id = ? 
    and m_users.id not in (select user_id from t_relationships where t_relationships.isdeactivated=false and t_relationships.cha_id=?)",
    session[:cha_id],session[:cha_id],session[:workspace_id],session[:cha_id])
    .group("m_users.name")

    sql=%(select m_users.name,t_relationships.id,t_relationships.user_id from m_users
    join t_relationships on m_users.id=t_relationships.user_id where 
    t_relationships.cha_id=? and t_relationships.workspace_id=? and t_relationships.isdeactivated=false),session[:cha_id],session[:workspace_id]
        
    @chamember=MUser.find_by_sql(sql).paginate(page: params[:page],per_page:10)
        
    @cha_member_count=MUser.select("count(*) as usercount")
    .joins("join t_relationships on m_users.id=t_relationships.user_id")
    .where("t_relationships.isdeactivated=false and t_relationships.workspace_id=? and t_relationships.cha_id=?",session[:workspace_id],session[:cha_id])
        
    menu
      
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
    if @chamsgid
      HChastarmsg.find_by(chamsg_id: params[:delclickchamsgid]).destroy
    end
    @chathread=HChaThread.find_by(chamsg_id: params[:delclickchamsgid])
    if @chathread
      HChaThread.select("*").where("chamsg_id=?", params[:delclickchamsgid]).destroy_all
    end
    redirect_back(fallback_location:channelmsg_path)
  end
  
  def removemember
    TRelationship.find(params[:user_id]).update(isdeactivated: true)
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
    @chamsg.workspace_id=session[:workspace_id]
   if @chamsg.save
    maxid=TChamsg.maximum('id')
      if @mention_u   
        @mention=HMention.new
        @mention.user_id = @mention_u.id
        @mention.chamsg_id= maxid
        @mention.save
      end
    @rs=TRelationship.where("cha_id=? and user_id!=? and workspace_id=?",session[:cha_id],session[:user_id],session[:workspace_id])
    @rs.each { |v|
        TRelationship.where(id: v.id).update_all(msg_count: v.msg_count+1)
     }
     redirect_back(fallback_location:channelmsg_path)
    end
  end
  
  def updatefun
    TRelationship.where(id: params[:trelationshipid]).update_all(isdeactivated: false)
    redirect_back(fallback_location:channelmsg_path)
  end

  def insertfun
      @enum_value = TRelationship.create(user_id: params[:userid], workspace_id: session[:workspace_id], cha_id: session[:cha_id], isdeactivated: false, msg_count:0)
      @enum_value.save
      redirect_back(fallback_location:channelmsg_path)
  end

  private
    def channelmsg_params
      params.require(:t_cha_msg).permit(:sendmsg)
    end
end
