require 'resque/server'
Rails.application.routes.draw do
#root to: "wordpress#show"
get 'wordpress/show'
  devise_for :admin_users, ActiveAdmin::Devise.config
  mount Resque::Server.new, at: '/jobs'
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
