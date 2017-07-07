Rails.application.routes.draw do

  resources :authors do
    resources :posts do
      member do
        post "unpublish"
      end
    end
    get "extension"
  end

  get "/usage" => "usage#index"
  get "/:post_token" => "posts#show"

  root "usage#index"

end
