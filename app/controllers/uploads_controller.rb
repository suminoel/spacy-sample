class UploadsController < ApplicationController
  before_action :authenticate_user!

  # carrierwaveでアップロードした画像の表示とダウンロード
  def show
    post_id = params[:id]
    filename = params[:filename]
    extension = params[:extension]
    filepath = Rails.root.join("uploads/post/images/#{post_id}", "#{filename}.#{extension}")
    stat = File::stat(filepath)

    # content-typeによって、表示かダウンロードか分ける。:disposition inline は表示。なければダウンロード。
    if extension == "jpg" || extension == "jpeg" || extension == "png" || extension == "gif" || extension == "bmp"
      send_file(filepath, :filename => filename, :length => stat.size, :type => "image/#{extension}", :disposition => "inline")
    elsif extension == "mp4" || extension == "mpeg" || extension == "ogg" || extension == "webm"
      send_file(filepath, :filename => filename, :length => stat.size, :type => "video/#{extension}", :disposition => "inline")
    elsif extension == "3gp"
      send_file(filepath, :filename => filename, :length => stat.size, :type => "video/3gpp", :disposition => "inline")
    elsif extension == "3g2"
      send_file(filepath, :filename => filename, :length => stat.size, :type => "video/3gpp2", :disposition => "inline")
    elsif extension == "mpe" || extension == "mpg"
      send_file(filepath, :filename => filename, :length => stat.size, :type => "video/mpeg", :disposition => "inline")
    elsif extension == "mov" || extension == "qt"
      send_file(filepath, :filename => filename, :length => stat.size, :type => "video/quicktime", :disposition => "inline")
    elsif extension == "asx"
      send_file(filepath, :filename => filename, :length => stat.size, :type => "video/x-ms-asf", :disposition => "inline")
    elsif extension == "asf" || extension == "wm" || extension == "wmv" || extension == "wmx"
      send_file(filepath, :filename => filename, :length => stat.size, :type => "video/x-ms-#{extension}", :disposition => "inline")
    elsif extension == "avi"
      send_file(filepath, :filename => filename, :length => stat.size, :type => "video/x-msvideo", :disposition => "inline")
    elsif extension == "movie"
      send_file(filepath, :filename => filename, :length => stat.size, :type => "video/x-sgi-movie", :disposition => "inline")
    elsif extension == "pdf"
      send_file(filepath, :filename => filename, :length => stat.size, :type => "application/pdf", :disposition => "inline")
    else
      send_file(filepath, :filename => filename, :length => stat.size)
    end
  end

  # ユーザーアバターの表示
  def show_avatar
    user_id = params[:id]
    filename = params[:filename]
    extension = params[:extension]
    filepath = Rails.root.join("uploads/user/avatar/#{user_id}", "#{filename}.#{extension}")
    stat = File::stat(filepath)
    send_file(filepath, :filename => filename, :length => stat.size, :type => "image/#{extension}", :disposition => "inline")
  end
end
