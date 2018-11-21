module ApplicationHelper
  
  #require "date"   #Dateクラスを使えるようにする ポートフォリオ版のため削除
  #def now_time
    #@now = Date.today  #Date.today(今日の日付)を変数todayに代入する
  #end

  # ページごとの完全なタイトルを返します。                   # コメント行
  def full_title(page_title = '')                     # メソッド定義とオプション引数
    base_title = "勤怠システム"  # 変数への代入
    if page_title.empty?                              # 論理値テスト
      base_title                                      # 暗黙の戻り値
    else 
      page_title + " | " + base_title                 # 文字列の結合
    end
  end
end
