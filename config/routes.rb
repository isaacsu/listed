Rails.application.routes.draw do

  resources :authors do
    member do
      get "settings"
      post "subscribe", :as => "subscribe"
    end
    resources :posts do
      member do
        post "unpublish"
      end
    end
    get "extension"
  end

  resources :subscriptions do
    get "confirm", :as => "subscriptions_confirm"
    get "unsubscribe", :as => "subscription_unsubscribe"
    get "update_frequency", :as => "subscription_update_frequency"
  end

  get "/usage" => "usage#index"

  get ':username/:id/:slug' => 'posts#show', :constraints => {:username => /@.*/}, as: 'slugged_post'
  get ':username' => 'authors#show', :constraints => {:username => /@.*/}

  get "/:post_token" => "posts#show"

  root "usage#index"

end
