class CreateChannelController < ApplicationController
  def createchannel
    @mcha = MCha.new   
  end
  def create
    @mcha = MCha.new(user_params)
    if @mcha.save
      flash[:success] = "Welcome"
      redirect_to msgsendandrec_path
    else
      render 'new'
    end
  end
  private

    def user_params
      params.require(:m_cha).permit(:name, :isprivate, :workspace_id)
    end
end
