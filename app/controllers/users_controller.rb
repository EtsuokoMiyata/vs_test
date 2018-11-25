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
    calendar #1か月分のカレンダー
    if params[:button_name] == nil
      #current_month #当月の表示と初日締日
      @current_day = Date.today
    else
      #arrow_month　#←ボタンが押された時の表示　初日締日
       if params[:button_name] == "last_month"
          @current_day = Time.parse(params[:first_day]).prev_month
       elsif params[:button_name] == "next_month" 
          @current_day = Time.parse(params[:first_day]).next_month
       else
       end
    end
  end
  
  def current_month #当月の表示と初日締日
    @current_day = Date.today
    
    #@year = Date.today.year
    #@month = Date.today.month
    #@first_day = Date.today.beginning_of_month
    #@last_day = Date.today.end_of_month
  end
  
  def arrow_month
    if params[:button_name] == "last_month"
      @current_day = @current_day.prev_month
      #@year = (Date.today).prev_month.year
      #@month = (Date.today).prev_month.month
      #@first_day = (Date.today.beginning_of_month).prev_month
      #@last_day = (Date.today.end_of_month).prev_month
    elsif params[:button_name] == "next_month" 
        @b = 1
      #@year
      #@month
      #@first_day
      #@last_day
    else
    end
  end
  
  
  def calendar #1か月分のカレンダー
    #@arrey = %x(Date.today.beginning_of_month..Date.today.end_of_month)
    @arrey=[]
    (Date.today.beginning_of_month..Date.today.end_of_month).each do |date|
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
