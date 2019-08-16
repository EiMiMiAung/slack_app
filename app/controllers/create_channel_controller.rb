class CreateChannelController < ApplicationController
  def createchannel
    @mcha = MCha.new

    menu
  end
  
  def create
    @mcha = MCha.new(user_params)
    if MCha.where(:name => @mcha.name , :workspace_id => @mcha.workspace_id).blank? 
      if @mcha.save
        maxid=MCha.maximum('id')
        @trs=TRelationship.new
        @trs.user_id=session[:user_id]
        @trs.workspace_id=session[:workspace_id]
        @trs.cha_id=maxid
        @trs.isdeactivated=false 
        @trs.msg_count=0 
        @trs.save  
        redirect_to msgsendandrec_path
      else
        flash[:chanameerrmsg] = 'チャネル名を入力してください！'
        redirect_to createchannel_path
      end
    else
      flash[:chanameerrmsg] = 'このチャンネル名は既にこのチャンネルで使用されています。他のチャンネル名を入力!'
      redirect_to createchannel_path     
    end
  end
  private
    def user_params
      params.require(:m_cha).permit(:name, :isprivate, :workspace_id)
    end
end
