class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  #ユーザーヘルパー  に移動
  #def time_to_date_J        #Date.todayの挙動がUTC時間のようなので、Time.now→Date関数に日本時間に変換
    #Date.parse((Time.now + 32400).to_s)
  #end
  
  

  private

    # ユーザーのログインを確認する
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
end