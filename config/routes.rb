Rails.application.routes.draw do

  resources :authors do
    resources :posts
    get "extension"
  end

  get "/usage" => "usage#index"
  get "/:post_token" => "posts#show"

  root "posts#index"

end
