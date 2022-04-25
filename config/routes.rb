require 'resque/server'
Rails.application.routes.draw do
  root to: "admin/dashboard#index", via: [:get, :post]
  get 'admin/dashboard/index'
  get 'frontend/site_timeline'
  post 'frontend/site_timeline'
  get 'frontend/source_timeline'
  post 'frontend/source_timeline'
  get 'frontend/cms_distribution'
  post 'frontend/cms_distribution'
  post 'admin/websites'
  devise_for :admin_users, ActiveAdmin::Devise.config
  mount Resque::Server.new, at: '/jobs'
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
