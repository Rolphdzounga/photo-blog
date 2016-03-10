Rails.application.routes.draw do
  resources :images
  devise_for :users, :controllers => { :registrations => 'registrations' }	
  get 'welcome/index'

  root 'welcome#index'

  
end
