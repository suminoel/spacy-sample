module ApplicationHelper

  require "uri"

  # text（post content）にあるURLをリンクに変更する関数
  # text string
  def text_url_to_link text
    cont = ""

    # text内にURLが含まれていない投稿の場合はnilを返す
    if !text.index("http")
      cont = nil
    else
      # text内にhttp, httpsの記述があれば下記を実行
      # urlを元に、サイトからogp情報をスクレイピングする
      URI.extract(text, ['http', 'https']).uniq.each do |url|
        sub_text = ""
        page = MetaInspector.new(url)
        title = page.title
        img = page.images.best
        desc = page.meta_tags['property']['og:description']
        site = page.host

        # 各々、nilの場合は空文字を返す
        title = title.present? ? title : ""
        img = img.present? ? img : ""
        desc = desc.present? ? strip_tags(desc.join) : ""
        site = site.present? ? site : ""

        # 半角@があるとリンクになってしまうので、全角＠に変換する
        desc = desc.tr('@', '＠')

        # ogp titleが空でなければ、ogp情報があるものと判断して下記を実行
        if title.present?
          sub_text = "<a class=\"og-card\" href=\"" << url << "\" target=\"_blank\">
              <div class=\"og-image\">
                <div class=\"og-image-box\" style=\"background-image: url(" << img << ");\"></div>
              </div>
              <div class=\"og-content\">
                <h2>" << title << "</h2>
                <p class=\"og-desc\">" << desc << "</p>
                <p class=\"og-sitename\">" << site << "</p>
              </div>
            </a>"

        # ogp titleが空だったらogp情報がないものと判断してテキストリンクにする
        else
          sub_text = "<a href=\"" << url << "\" target=\"_blank\">" << url << "</a>"
        end

        cont << sub_text
      end
    end

    return cont
  end

  # text_url_to_linkで変換したcontentがDBに保存できなかったときの回避策
  # OGPスクレイピング、HTML整形をせず、単純にURLの文字列だけをリンクに変換して返す
  def rescue_text_url_to_link text
    URI.extract(text, ['http', 'https']).uniq.each do |url|
      sub_text = ""
      sub_text << "<a href=\"" << url << "\" target=\"_blank\">" << url << "</a>"
      text.gsub!(url, sub_text)
    end

    # リプライ：contentの中に@があれば、リプライ先のユーザー詳細のリンクを付ける
    if @reply_user_id.present?
      text.gsub!(/@(.+?)さん/, "<a href=\"/users/#{@reply_user_id}\">@\\1</a>さん ")
    end

    return text
  end

  # 現在開いているページのコントローラー名とアクション名を取得して分岐するヘルパーアクション
  def current_page(controller_name, action_name)
    controller.controller_name == controller_name && controller.action_name == action_name
  end

end
