class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  require "date"   #Dateクラスを使えるよう
  require "time"   # Timeクラスを使えるよ
  
  def index
     #@users = User.paginate(page: params[:page])
      @users = User.where(activated: true).paginate(page: params[:page]).search(params[:search])
  end
  
  #-------------これより勤怠表示画面-------------------
  def show  #ログイン画面から　paramsのidを取得する
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    
    if params[:button_name] == nil
      @current_day = Date.today                         #現在の日時を取得
      @first_day = Date.today.beginning_of_month
      @last_day = Date.today.end_of_month
      calendar #1か月分のカレンダー
    else
      
       if params[:button_name] == "last_month"          #前月矢印が押された時
          @first_day = Date.strptime(params[:first_day]).prev_month.beginning_of_month
          @last_day = Date.strptime(params[:last_day]).prev_month.end_of_month
          @current_day = Date.strptime(params[:current_day]).prev_month
          
          calendar #1か月分のカレンダー
        elsif params[:button_name] == "next_month"       #次月矢印が押された時 
          @first_day = Date.strptime(params[:first_day]).next_month.beginning_of_month
          @last_day = Date.strptime(params[:last_day]).next_month.end_of_month
          @current_day = Date.strptime(params[:current_day]).next_month
          calendar #1か月分のカレンダー
        else
       end
    end
  end
  
  
  def calendar #1か月分のカレンダー
    @arrey=Array.new
    (@first_day..@last_day).each do |date|
    @arrey.push(date)
    end
  end
#--------------これまで勤怠表示画面------------------------  
  
  
  def new
     @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "メールを確認してアカウントを有効にしてください。"
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールが更新されました。"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーが削除されました。"
    redirect_to users_url
  end
  
  def following
    @title = "フォロー"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
   private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
  
  # beforeフィルター
  
  
  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
  
  # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  
end
