class UsersController < ApplicationController
  before_action :authenticate_user!

  # 1ページで表示するPostの数
  PER = 10

  # ユーザー一覧
  def index
    @users = User.where(leave_at: nil)

    # tagのタブ用
    @tags = TAGS

    # 新規投稿
    @post = Post.new

    # respond_to do |format|
    #   format.json { render json: @users, adapter: :json }
    #   format.any
    # end
  end

  # ユーザー詳細（該当ユーザーの投稿一覧）
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.includes(:tags, :taggings).order(created_at: :desc).page(params[:page]).per(PER)

    # tagのタブ用
    @tags = TAGS

    # 新規投稿
    @post = Post.new

    # respond_to do |format|
    #   format.json { render json: {:user => @user, :posts => @posts} }
    #   format.any
    # end
  end

  # ユーザー詳細（該当ユーザーのいいね一覧）
  def likes
    @user = User.find_by(id: params[:id])
    @likes = Like.where(user_id: @user.id).order(created_at: :desc).page(params[:page]).per(PER)

    # tagのタブ用
    @tags = TAGS

    # 新規投稿
    @post = Post.new

    # respond_to do |format|
    #   format.json { render json: {:user => @user, :likes => @likes} }
    #   format.any
    # end
  end

  # ユーザー詳細（該当ユーザーのブックマーク一覧）
  def bookmarks
    @user = User.find_by(id: params[:id])
    @bookmarks = Bookmark.where(user_id: @user.id).order(created_at: :desc).page(params[:page]).per(PER)

    # tagのタブ用
    @tags = TAGS

    # 新規投稿
    @post = Post.new
  end

  # ユーザー詳細（該当ユーザーへのリプライ一覧）
  def reply
    @user = User.find_by(id: params[:id])
    @posts = Post.where(reply_user_id: @user.id).includes(:tags, :taggings).order(created_at: :desc).page(params[:page]).per(PER)

    # tagのタブ用
    @tags = TAGS

    # 新規投稿
    @post = Post.new

    # respond_to do |format|
    #   format.json { render json: {:user => @user, :posts => @posts} }
    #   format.any
    # end
  end
end
