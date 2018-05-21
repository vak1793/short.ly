Rails.application.routes.draw do
  resources :links, param: :url

  match ':short_url' , to: 'links#relay', via: :get
end
