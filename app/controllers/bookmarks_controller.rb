class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    @bookmark = Bookmark.create(user_id: current_user.id, post_id: params[:post_id])
    @bookmarks = Bookmark.where(post_id: params[:post_id])
    @post = Post.find_by(id: params[:post_id])
  end

  def destroy
    bookmark = Bookmark.find_by(user_id: current_user.id, post_id: params[:id])
    bookmark.destroy
    @bookmarks = Bookmark.where(post_id: params[:id])
    @post = Post.find_by(id: params[:id])
  end

end
