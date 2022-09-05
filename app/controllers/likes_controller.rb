class LikesController < ApplicationController
  before_action :authenticate_user!

  # Likeボタンをクリックしたとき
  # @like likesテーブルにrecordをcreateして、current_userのidをuser_idに保存、post_idにLikeしたポストidを保存
  # @likes 同一のポストidでLikeされているrecordを取得
  # @post LikeしたPostを取得
  def create
    @like = Like.create(user_id: current_user.id, post_id: params[:post_id])
    @likes = Like.where(post_id: params[:post_id])
    @post = Post.find_by(id: params[:post_id])

    # respond_to do |format|
    #   format.json { render json: @post, @like, @likes, adapter: :json }
    #   format.any
    # end
  end

  # すでにLikeしているPostのLikeボタンをクリックしたとき
  # like.destroy likeの取り消し（recordの削除）
  # @likes 同一のポストidでLikeされているrecordを取得
  # @post LikeしたPostを取得
  def destroy
    like = Like.find_by(user_id: current_user.id, post_id: params[:id])
    like.destroy
    @likes = Like.where(post_id: params[:id])
    @post = Post.find_by(id: params[:id])
  end

end
