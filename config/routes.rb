Rails.application.routes.draw do
  apipie
  resources :education_histories
  resources :work_histories
  resources :resumes
  devise_for :users
  root 'welcome#index'

  #api
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :create, :show, :update, :destroy]
      resources :users do
      	resources :resumes, only: [:index, :create, :show, :update, :destroy]
        resources :resumes do
	 resources :work_histories, only: [:index, :create, :show, :update, :destroy]
	 resources :education_histories, only: [:index, :create, :show, :update, :destroy]
	end
      end
    end
  end

end
