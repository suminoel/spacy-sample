class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

  # 1ページで表示するPostの数
  PER = 10

  # 投稿一覧画面
  def index

    # paramsにtagがあったら
    if params[:tag]
      # そのtagが付いているPostだけを取得
      @posts = Post.tagged_with(params[:tag])

    # paramsにq（検索ワード）があったらgem ransackを使用して、contentに検索ワードを含むPostだけを取得
    elsif params[:q]
      # splitで空白で区切られたワードを配列にし、グループ化したパラメータを発行。それらがすべて含まれるPostを取得する
      query = params[:q].split(/[[:space:]]/)
      grouping_hash = query.reduce({}){|hash, word| hash.merge(word => { html_content_cont_all: word })}
      @keyword = Post.ransack({ combinator: 'and', groupings: grouping_hash })
      @posts = @keyword.result

    # paramsが何もない場合は、すべてのPostを取得
    else
      @posts = Post.all
    end

    # tagのタブ用
    @tags = TAGS

    # それぞれ上記で取得したPostをdescで並び変える
    # includes(:tags, :taggings) N+1問題の回避（SQLを複数発行しないための記述）
    @posts = @posts.includes(:tags, :taggings).order(created_at: :desc).page(params[:page]).per(PER)

    # 新規投稿
    @post = Post.new

    # respond_to do |format|
    #   format.json { render json: @posts }
    #   format.any
    # end
  end



  # 各投稿の詳細（該当Postへのリプライ一覧）
  def show
    # paramsのidと一致したPostだけを取得
    @post = Post.find(params[:id])

    # 取得したPostのreply_parent_idカラムが空でなければ
    if @post.reply_parent_id.present?
      # reply_parent_idの値を取得（現在のPostが別Postへのリプライであると判断）
      @parent_id = @post.reply_parent_id

    # reply_parent_idが空の場合は、reply_parent_idを、現在のPostのidとする（現在のPostはリプライではないと判断）
    else
      @parent_id = @post.id
    end

    # 親Post（id）と子Post（reply_parent_id）をすべて取得
    @posts = Post.where("id = ? OR reply_parent_id = ?", @parent_id, @parent_id).includes(:tags, :taggings).order(likes_count: :desc).page(params[:page])

    # tagのタブ用
    @tags = TAGS

    # 新規投稿
    @post = Post.new

    # respond_to do |format|
    #   format.json { render json: @posts }
    #   format.any
    # end
  end



  # いいねランキングページ
  def like_rank
    # 年月selectを作成するための処理
    # 一旦、すべてのPostを取得
    @all = Post.all.order(created_at: :desc)
    # 取得したPostを年月でグループ化
    @months = @all.group_by{|x| x.created_at.strftime('%Y-%m')}
    # グループ化したPostのkeyの値（%Y-%m）だけを取得
    @date = @months.keys

    # paramsにdate_selectがあったら
    if params[:date_select]
      # created_atにselect_dateを含むPostだけを取得
      # likes_countが0のものはあっても意味ないので除外する
      select_date = params[:date_select]
      @posts = Post.where("created_at like '%#{select_date}%'").where(likes_count: 1..Float::INFINITY)

    # paramsにdate_selectがない場合は、今月（Time.now.all_month）に投稿され、かつlikes_countが1以上のPostを取得する
    else
      @posts = Post.where(created_at: Time.now.all_month, likes_count: 1..Float::INFINITY)
    end

    # 上記で取得したPostをlikes_countの降順で並べる
    @posts = @posts.includes(:tags, :taggings).order(likes_count: :desc).page(params[:page]).per(PER)

    # tagのタブ用
    @tags = TAGS

    # 新規投稿
    @post = Post.new

    # respond_to do |format|
    #   format.json { render json: @posts }
    #   format.any
    # end
  end



  # ブックマークランキングページ
  def bookmark_rank
    @all = Post.all.order(created_at: :desc)
    @months = @all.group_by{|x| x.created_at.strftime('%Y-%m')}
    @date = @months.keys

    if params[:date_select]
      select_date = params[:date_select]
      @posts = Post.where("created_at like '%#{select_date}%'").where(bookmarks_count: 1..Float::INFINITY)
    else
      @posts = Post.where(created_at: Time.now.all_month, bookmarks_count: 1..Float::INFINITY)
    end

    @posts = @posts.includes(:tags, :taggings).order(bookmarks_count: :desc).page(params[:page]).per(PER)

    # tagのタブ用
    @tags = TAGS

    # 新規投稿
    @post = Post.new
  end



  # 投稿ランキングページ
  def post_count
    # 年月selectを作成するための処理
    @all = Post.all.order(created_at: :desc)
    @months = @all.group_by{|x| x.created_at.strftime('%Y-%m')}
    @date = @months.keys

    # 上に解説があるので省略
    # select_dateに加え、contentにhttpが入っている投稿のみを取得
    # whereの書き順に注意。下記の場合 (B or C) and A となるので、and条件のcreated_atを最後に書いている。
    if params[:date_select]
      select_date = params[:date_select]
      @posts = Post.where.not("html_content like '%href=\"/users/%'").where("created_at like '%#{select_date}%'")
      # 先月月初の日付：パラメータの日付をDateオブジェクトに変換
      @prev_month = Date.strptime(select_date, "%Y-%m").prev_month
      # 先月の投稿すべてを取得
      @prev_posts = Post.where.not("html_content like '%href=\"/users/%'").where("created_at like '%#{@prev_month.strftime('%Y-%m')}%'")
    else
      @posts = Post.where.not("html_content like '%href=\"/users/%'").where(created_at: Time.now.all_month)
      @prev_month = Date.current.prev_month.beginning_of_month
      @prev_posts = Post.where.not("html_content like '%href=\"/users/%'").where("created_at like '%#{@prev_month.strftime('%Y-%m')}%'")
    end

    # 今月の投稿数を取得
    @current_count = @posts.includes(:tags, :taggings).order("count(*) desc").count
    # 先月の投稿数を取得
    @prev_count = @prev_posts.includes(:tags, :taggings).order("count(*) desc").count
    # 前月投稿比 (今月投稿数 / 先月投稿数) * 100（小数点第二位で四捨五入）
    @month_basis = ((@current_count.to_f / @prev_count.to_f) * 100).round(2)
    # 上記で取得したPostをユーザーでグループ化し、user_idを配列で取得
    @user_ids = @posts.group(:user_id).select("user_id").map{|m| m.user_id}
    # where.notで@user_idsにないユーザー（投稿数0件のユーザー）のIDを取得
    @users_list = User.where.not(id: @user_ids).where.not(user_name: "退会ユーザー")
    # 投稿数0件のユーザーIDを配列で取得
    @users = @users_list.map{|m| m.id}
    # 上記で取得したPostをユーザーでグループ化し、カウント。そのカウントの降順で並べる
    @posts = @posts.group(:user_id).includes(:tags, :taggings).order("count(*) desc").count

    # tagのタブ用
    @tags = TAGS

    # 新規投稿
    @post = Post.new

    # respond_to do |format|
    #   format.json { render json: {:date => @date,
    #                               :current_count => @current_count,
    #                               :prev_count => @prev_count,
    #                               :month_basis => @month_basis,
    #                               :users => @users,
    #                               :posts => @posts
    #                              }
    #               }
    #   format.any
    # end
  end



  # タグ検索ページ
  def tags_search
    # 定義した定数の値を足してるだけ。詳しくはcofig > initializers > define.rbを参照
    @tags = TAGS + AUTO_TAGS

    # paramsにtag_listがある場合は、該当するtagの付いたPostを取得（AND検索）
    if params[:tag_list]
      @posts = Post.tagged_with(params[:tag_list]).includes(:tags, :taggings).order(created_at: :desc).page(params[:page]).per(PER)

    # paramsにtag_listがない場合は、何も表示しない
    else
      @posts = ""
    end

    # 新規投稿
    @post = Post.new

    # respond_to do |format|
    #   format.json { render json: @posts }
    #   format.any
    # end
  end



  # 新規投稿
  def new
    # paramsにidがある場合
    if params[:id]
      # 同一id（リプライ先）のPostのuserを取得
      @reply_post = Post.find(params[:id])
      @user = @reply_post.user

      # リプライするPostのreply_parent_idが空でない場合
      if @reply_post.reply_parent_id.present?
        # @parent_idにreply_parent_idをセット
        @parent_id = @reply_post.reply_parent_id

      # リプライするPostのreply_parent_idが空の場合
      else
        # リプライ先のPost idをセット（これが親のPost idになる）
        @parent_id = @reply_post.id
      end

      # contentに@ユーザー名さんをセット
      # reply_user_idにリプライ相手のuser_idをセット
      # reply_parent_idに、上記で作った変数@parent_idの値をセット
      # Post.newで新規投稿を作る（まだDBに保存はされない）
      @post = Post.new(
        content: "@#{@user.user_name}さん ",
        reply_user_id: @user.id,
        reply_parent_id: @parent_id
      )

    # paramsにidがない場合は、空の状態でPost.newする
    else
      @post = Post.new
    end

    # tagのタブ用
    @tags = TAGS

    # respond_to do |format|
    #   format.json { render json: @post }
    #   format.any
    # end
  end



  # 新規投稿の保存ルーチン
  #
  # @tag_list array
  # @file array
  def create
    # 新規投稿画面でつけたtagとfileを取得して格納
    @tag_list = params[:post][:tag_list]
    @file = params[:post][:images]
    @reply_user_id = params[:post][:reply_user_id]
    @content = params[:post][:content]

    # @fileが空でない場合
    if @file.present?

      # @fileのarrayの分だけループさせる
      @file.each do |image|

        # 添付ファイルが画像だったら「画像」タグを追加
        if image.content_type.index("image")
          @tag_list.push("画像")

        # 添付ファイルがaudioファイルだったら「音声」タグを追加
        elsif image.content_type.index("audio")
          @tag_list.push("音声")

        # 添付ファイルがvideoファイルだったら「動画」タグを追加
        elsif image.content_type.index("video")
          @tag_list.push("動画")

        # 添付ファイルが上記以外のタイプだったら「ファイル」タグを追加
        else
          @tag_list.push("ファイル")
        end
      end
    end

    # 直接コンテンツ内に@名前を打ち込んだ場合、@名前に一致するユーザーIDを@reply_user_idにセットする
    if @reply_user_id.empty? && @content.index('@')
      @user_name = @content[/@(.*?)さん/, 1]
      @user_record = User.find_by(user_name: @user_name)
      @reply_user_id = @user_record.id
    end

    # 入力された情報＋上記の処理を元にPost.newする
    @post = Post.new(
      content: @content,
      html_content: @content,
      og_card: @content,
      images: @file,
      tag_list: @tag_list,
      user_id: current_user.id,
      reply_user_id: @reply_user_id,
      reply_parent_id: params[:post][:reply_parent_id]
    )

    # ここでDBに保存
    # 保存が成功した場合
    if @post.save

      # view_context：load hepler method
      # contentの中のURLをリンクにする（helpers/application_helper.rbを参照）
      # saveした時点でupdateをかける理由は、newで下記処理をやると、contentまで書き換わってしまうため
      # まずcontentをplaineで保存し、その後でHTMLに変換したcontentをhtml_contentカラムに保存（update）している
      @post.update_attribute(:html_content, view_context.rescue_text_url_to_link(@post.html_content))

      # 上記と同様に、og_cardカラムにはcontent内のurlだけを取得し、ブログカード形式にしたデータだけを入れる
      begin
        @post.update_attribute(:og_card, view_context.text_url_to_link(@post.og_card))
      rescue
        # なんらかのエラーでog_cardがDBに保存できなかったときの対策
        # このままだとog_cardが、ただのcontentになるので、NULLにして保存する
        @post.update_attribute(:og_card, nil)
      end


      # Chatworkに代理投稿する
      @chatwork = Chatwork.new
      @chatwork.push_chatwork_message(@post)

      # respond_to do |format|
      #   format.json { render json: @post }
      #   format.any
      # end

      # 投稿一覧にリダイレクトして「投稿しました」メッセージを表示する
      flash[:success] = "投稿しました"
      redirect_to posts_url

    # 保存に失敗した場合は、ページをリロードする
    else
      # respond_to do |format|
      #   format.json { render json: { error: @post.errors } }
      #   format.any { render 'posts/new' }
      # end
      render 'posts/new'
    end
  end



  # 投稿編集ページ
  def edit
    # 編集するPostを取得
    @post = Post.find(params[:id])
    # tag_listを,で区切って、flattenで一次元配列にする（なぜか多次元配列になったので）
    @tag_list = @post.tag_list.split(",").flatten

    # tagのタブ用
    @tags = TAGS

    # respond_to do |format|
    #   format.json { render json: @post }
    #   format.any
    # end
  end



  # 投稿の更新 処理内容はcreateとほぼほぼ同じなので省略
  def update
    @post = Post.find(params[:id])
    @tag_list = params[:post][:tag_list]
    @file = params[:post][:images]
    @content = params[:post][:content]

    if @file.present?
      @file.each do |image|
        if image.content_type.index("image")
          @tag_list.push("画像")
        elsif image.content_type.index("audio")
          @tag_list.push("音声")
        elsif image.content_type.index("video")
          @tag_list.push("動画")
        else
          @tag_list.push("ファイル")
        end
      end
    elsif @post.images.present?
      @post.images.each do |image|
        if image.content_type.index("image")
          @tag_list.push("画像")
        elsif image.content_type.index("audio")
          @tag_list.push("音声")
        elsif image.content_type.index("video")
          @tag_list.push("動画")
        else
          @tag_list.push("ファイル")
        end
      end
    end

    if @post.update_attributes(post_params)
      @post.update_attribute(:content, @content)
      @post.update_attribute(:html_content, @content)
      @post.update_attribute(:og_card, @content)
      @post.update_attribute(:images, @file)
      @post.update_attribute(:tag_list, @tag_list)

      @post.update_attribute(:html_content, view_context.rescue_text_url_to_link(@post.html_content))
      @post.update_attribute(:og_card, view_context.text_url_to_link(@post.og_card))

      flash[:success] = "投稿を編集しました"
      redirect_to posts_url
    else
      render 'posts/edit'
    end
  end



  # 投稿の削除
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to posts_url
  end



  # もし悪意のある者がアドレス直打ちで投稿を編集しようとした場合
  # ログインしているユーザー以外の場合は「権限がありません」と表示して編集させないようにする処理
  def ensure_correct_user
    @post = Post.find(params[:id])
    if @post.user_id != current_user.id
      flash[:notice] = "権限がありません"
      redirect_to posts_url
    end
  end



  # 投稿の更新で使用 permitで指定した内容を更新させる
  def post_params
    params.require(:post).permit(:content, :html_content, :og_card, :tag_list, :images, :images_cache)
  end
end
