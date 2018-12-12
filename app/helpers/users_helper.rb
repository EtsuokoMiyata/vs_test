module UsersHelper
    def work_in_button(date)
    if date == Date.today
       @work_in_button = raw('<button type="button" class="btn btn-default">出社</button>')
    else
    end
    end
    
    
    
    
    
  
   # 引数で与えられたユーザーのGravatar画像を返す
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
