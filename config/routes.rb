Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'
  get 'posts/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, module: :users
  resources :users, :only => [:index, :show]

  # /api/v1/authでアクセス可能
  # namespace :api, format: 'json' do
  #   namespace :v1 do
  #     mount_devise_token_auth_for 'User', at: 'auth'
  #   end
  # end

  get "/" => "posts#index"
  get "posts/like_ranking" => "posts#like_rank"
  get "posts/bookmark_ranking" => "posts#bookmark_rank"
  get "posts/post_count_ranking" => "posts#post_count"
  get "posts/tags_search" => "posts#tags_search"
  get "posts/new" => "posts#new"
  get "posts/:id/reply" => "posts#new"
  post "posts/create" => "posts#create"
  get "posts/:id" => "posts#show"
  get "posts/:id/edit" => "posts#edit"
  post "posts/:id/update" => "posts#update"
  post "posts/:id/destroy" => "posts#destroy"

  get 'tags/:tag', to: 'posts#index', as: :tag

  get "users/:id/likes" => "users#likes"
  get "users/:id/bookmarks" => "users#bookmarks"
  get "users/:id/reply" => "users#reply"

  get "uploads/post/images/:id/:filename.:extension" => "uploads#show"
  get "uploads/user/avatar/:id/:filename.:extension" => "uploads#show_avatar"

  resources :posts, only: %w(index)

  resources :posts, shallow: true do
    resources :likes, only: [:create, :destroy]
    resources :bookmarks, only: [:create, :destroy]
  end
end
