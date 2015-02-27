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
  # list works by related model
  get '/characters/:character_id/works' => 'works#character_index'
  get '/identities/:identity_id/works'  => 'works#identity_index'
  get '/concepts/:concept_id/works'     => 'works#concept_index'


  resources :casts, except: [:index, :new, :show]
  resources :chapters, except: [:index, :new, :show]
  resources :notes, except: [:index, :new, :show]

  resources :characters 
  resources :concepts
  resources :identities
  resources :items
  resources :relators

  # static pages
  get 'tags'  => 'static_pages#tags'
  get 'help'  => 'static_pages#help'
  get 'about' => 'static_pages#about'
  root 'static_pages#home'
end
