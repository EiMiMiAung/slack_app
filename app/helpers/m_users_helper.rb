module MUsersHelper
    def signup(user)
        session[:user_id]=user.id
        session[:user_name]=user.name
    end
    
end
