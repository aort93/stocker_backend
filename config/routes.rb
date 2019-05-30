Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users
  resources :articles
  resources :companies
  resources :purchased_stocks
  resources :watchlists

  get "/home_articles", to: "articles#retrieve"
  post "/login", to: "auth#login"
	get "/auto_login", to: "auth#auto_login"
  post "/article", to: "articles#single_article"

  post "/purchase", to: "companies#buy_stocks"
  post "/sell", to: "companies#sell_stocks"
  post "/watch", to: "companies#watchlist"
  post "/portfolio/", to: "companies#portfolio"

end
