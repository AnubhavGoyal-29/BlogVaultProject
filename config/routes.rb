require 'resque/server'
Rails.application.routes.draw do
  root to: "frontend#cms_distribution", via: [:get, :post]
  post 'frontend/site_timeline'
  post 'frontend/source_timeline'
  devise_for :admin_users, ActiveAdmin::Devise.config
  mount Resque::Server.new, at: '/jobs'
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
