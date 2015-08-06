Rails.application.routes.draw do
  resources :education_histories
  resources :work_histories
  resources :resumes
  devise_for :users
  root 'welcome#index'

end
