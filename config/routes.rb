
Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  mount BaseApi, at: 'api'
  mount Open::Base, at: 'open_api'
end
