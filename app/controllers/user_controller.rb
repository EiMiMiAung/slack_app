class UserController < ApplicationController
    def new
        @m_user = MUser.new
      end
      def create
        @@m_user = MUser.new(user_params)
        @@user=MUser.find_by(email: @@m_user[:email])
        if @@m_user.save==false
          redirect_to createspace_url
        elsif @@m_user.save
            redirect_to createspace_url
          # Handle a successful save.
        else
          render 'new'
        end
      end
      def test
        @user_list=MUser.find_by_sql("select name from m_users 
        join t_relationships on m_users.id=t_relationships.user_id where t_relationships.workspace_id=1
        and t_relationships.isdeactivated=0")
        @user_list1=MUser.find_by_sql("select * from m_users")
    
      end
      def member_management
        @user=MUser.select("distinct name,m_users.id").joins("join t_relationships on m_users.id=t_relationships.user_id").
    where("t_relationships.isdeactivated=0 and t_relationships.workspace_id=? and t_relationships.user_id!=?",session[:workspace_id],session[:user_id]) 
        @cha=MCha.where("workspace_id=?",session[:workspace_id])

         @user_list=MUser.select("*").joins("join t_relationships on m_users.id=t_relationships.user_id")
         .where("t_relationships.isdeactivated=? and t_relationships.workspace_id=?",0,session[:workspace_id])
      end
      def remove
        @trid=TRelationship.find(params[:user_id])
        @trid.isdeactivated=true
        @trid.save
        redirect_to membermanagement_path
      end
      
      private

    def user_params
      params.require(:m_user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
   
end
