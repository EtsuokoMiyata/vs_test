Rails.application.routes.draw do
  
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'
  

  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup', to: 'users#new'
  post '/signup',  to: 'users#create' 
  
  
  
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users do
    member do
      get :following, :followers
    end
  end
  
  
  #resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :attendances                                                       
  #resources :relationships,       only: [:create, :destroy]    #勤怠Bでは不要のためコメントアウト
  
  get '/basic_info/:id',    to: 'users#basic_info', as: 'basic_info'    #特定のユーザーの指定基本時間を表示するページ
  post  '/basic_info_edit',    to: 'users#basic_info_edit'   #特定のユーザーの指定基本時間を更新
  post  '/attendance_update_all',    to: 'attendances#attendance_update_all'   #勤怠編集ページを更新
  
end
