class Chatwork < ApplicationRecord
  require 'net/https'
  require 'json'
  require 'uri'

  def push_chatwork_message(post)
    @post = post
    @user = User.find_by(id: @post.user_id)
    @to = User.find_by(id: @post.reply_user_id)

    @uri = URI.parse('https://api.chatwork.com')
    @client = Net::HTTP.new(@uri.host, 443)
    @client.use_ssl = true

    ##### ChatWork APIトークン (~/.bashrcに追加した環境変数から取得する)
    @chatwork_api_token = ENV['CHATWORK_API_KEY']

    ##### ChatWorkへメッセージを通知するルームID (~/.bashrcに追加した環境変数から取得する)
    @message_room_id = ENV['CHATWORK_ROOM_ID']

    ##### ChatWorkへ通知するメッセージタイトル
    @message_title = "Spacyに投稿がありました。"

    ##### og_cardカラムから記事タイトルとリンクを抜粋
    begin
        # タイトル取得 return array
        @url_title = @post.og_card.scan(/<h2>(.+?)<\/h2>/).flatten
        # URL取得 return array
        @url_href = @post.og_card.scan(/href="(.*?)"/).flatten
        # @url_titleの配列の数をカウント
        @num = @url_title.count
        @share_text = ""
        # 配列の数だけループさせて@url_titleと@url_hrefの中身を取り出し、@share_textに追加していく
        @num.times do |i|
            @share_text.concat("#{@url_title[i]}\n#{@url_href[i]}\n\n")
        end
    rescue
        @share_text = ""
    end

    ##### リプライ：contentの中に@があれば、Toを付けてChatWorkに投稿する
    if @post.reply_user_id.present?
        @content = @post.content.gsub!(/@(.+?)さん/, "[To:#{@to.chatwork}] \\1さん\n")
    else
        @content = @post.content
    end

    ##### @content内のURL（改行含む）を削除
    if @share_text.present?
        @content.gsub!(/^http(.*)/) {|str| ""}
    end

    ##### ChatWorkへ通知するメッセージ
    @message_content = @content.truncate(200)

    ##### Chatworkへ通知する内容
    @message_text = "[info][title]" << @message_title << "[/title]"
    @message_text = @message_text << @user.user_name << "\n[hr]#{@share_text}#{@message_content}\n[hr]https://example.com/posts/#{@post.id}[/info]"

    ##### ChatWorkへメッセージ送信
    @res = @client.post( "/v2/rooms/#{@message_room_id}/messages", "body=#{ERB::Util.url_encode(@message_text)}", {"X-ChatWorkToken" => "#{@chatwork_api_token}"} )

    puts JSON.parse(@res.body)
  end
end
