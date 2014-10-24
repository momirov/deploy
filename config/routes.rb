Deploy::Application.routes.draw do
  resources :deployments do
    get 'kill'
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  resources :ssh_keys do
  end
  resources :projects do
    member do
      get 'diff/:commit(/:head)', :action => :diff, :as => :diff
    end
    resources :stages do
      member do
        get :deploy
        get :rollback
        get :current_version
        get :next_version
      end
    end
  end

  devise_for :users
  root :to => 'projects#index'
end
