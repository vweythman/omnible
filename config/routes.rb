Rails.application.routes.draw do

  match '/403' => 'errors#403', via: :all
  match '/404' => 'errors#404', via: :all
  match '/406' => 'errors#406', via: :all
  match '/422' => 'errors#422', via: :all
  match '/500' => 'errors#500', via: :all

  resources :users
  
  resources :anthologies

  resources :works do
    resources :casts
    resources :chapters
    resources :notes
  end

  resources :casts, except: [:index, :new, :show]
  resources :chapters, except: [:index, :new, :show]
  resources :notes, except: [:index, :new, :show]

  resources :characters do
    resources :opinions
  end
  resources :identities
  resources :relators
  resources :concepts

  # static pages
  get 'tags'  => 'static_pages#tags'
  get 'help'  => 'static_pages#help'
  get 'about' => 'static_pages#about'
  root 'static_pages#home'
end
