Rails.application.routes.draw do
  get 'refresh/new'
  root 'static_pages#home'
  
  get    '/signin',   to: 'sessions#new'
  post   '/signin',   to: 'sessions#create'
  get '/logout',  to: 'sessions#destroy'
  get '/main',   to:'static_pages#home'
  post '/main',   to:'static_pages#msgsendandrec'
  
 
  post '/mentionname', to:'cha_msgcon#mentionname'
  get '/mentionname', to:'cha_msgcon#mentionname'

  get '/channelmsg', to:'cha_msgcon#cha_msgcon'
  post '/channelmsgsend', to:'cha_msgcon#create'

  get '/channelunstar', to:'cha_msgcon#unstar'
  get '/chamsgdelete', to:'cha_msgcon#delete'
  get '/channelstar', to:'cha_msgcon#star'
  get '/thread',to:'thread#thread'

  get '/allunread',to:'all_unread#allunread'
  post '/allunread', to: 'all_unread#allread'
 
  get  '/createchannel', to: 'create_channel#createchannel'
  post '/createchannel',  to: 'create_channel#create'
  get '/mentionmember', to: 'cha_msgcon#mentionmember'
  
  get  '/channelmanagement',   to: 'user#channel_management'
  get  '/updatefun', to: 'cha_msgcon#updatefun'
  
  get '/insertfun',  to: 'cha_msgcon#insertfun'


  get  '/membermanagement',   to: 'user#member_management'

  get '/remove',  to: 'user#remove'
  get '/delete',  to:  'user#delete'
  get '/removemember',  to: 'cha_msgcon#removemember'
  get  '/test',    to: 'user#test'
  get  '/createworkspaces', to: 'm_users#new'
  post  '/create', to: 'm_users#create'
  
  get '/directmsg', to:'direct_msgcon#direct_msgcon'
  post '/direct', to:'direct_msgcon#create'
  
  get '/dirunstar', to:'direct_msgcon#unstar'
  get '/dirstar', to:'direct_msgcon#star'
  
  get '/threadmsg', to:'thread_chamsg#thread_chamsg'
  post '/threadcreate', to:'thread_chamsg#create'
  get '/dirthreadmsg', to:'thread_dirmsg#thread_dirmsg'
  get '/dirthread', to:'thread_dirmsg#thread_msgsend'
  post '/dirthread', to:'thread_dirmsg#create'

  get  '/createworkspace', to: 'workspaces#new'
  post '/creatework', to: 'workspaces#creatework'

  get '/msgsendandrec' , to: 'static_pages#msgsendandrec'
  get  'invitemember', to:'invitations#invitemember'
  post  'invitations', to:'invitations#create'
  get '/editjoinworkspace', to:'joinworkspaces#edit'
  post   '/editjoinworkspace',  to: 'joinworkspaces#create'

  get  '/starmessage', to: 'star_messages#new'
  get  '/directunstarmsg', to: 'star_messages#directstarmsgdestroy'
  get  '/channelunstarmsg', to: 'star_messages#channelstarmsgdestroy'

  get '/dirmsgdelete', to:'direct_msgcon#delete'
  get  '/mentionmessage', to: 'h_mentions#show'

  get '/refresh', to:'refresh#new'
   
  resources :m_users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
