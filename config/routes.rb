Rails.application.routes.draw do

  match '/403' => 'errors#403', via: :all
  match '/404' => 'errors#404', via: :all
  match '/406' => 'errors#406', via: :all
  match '/422' => 'errors#422', via: :all
  match '/500' => 'errors#500', via: :all

  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end

  resources :users
  
  resources :anthologies
  resources :works, :concerns => :paginatable do
    resources :casts
    resources :chapters
    resources :notes
  end
  resources :characters
  resources :qualities
  resources :items
  resources :places

  # list works by related model
  get '/characters/:character_id/works'     => 'works#character_index',     as: :character_works
  get '/concepts/:concept_id/works'         => 'works#concept_index',       as: :concept_works
  get '/identities/:identity_id/works'      => 'works#identity_index',      as: :identity_works
  get '/identities/:identity_id/characters' => 'characters#identity_index', as: :identity_characters 

  resources :chapters, except: [:index, :new, :show]
  resources :notes,    except: [:index, :new, :show]

  resources :concepts
  resources :activities
  resources :identities
  resources :relators

  # overview pages
  get 'tags'     => 'tags#index'
  get 'subjects' => 'subjects#index'
  
  # static pages
  get 'help'  => 'static_pages#help'
  get 'about' => 'static_pages#about'
  root 'static_pages#home'
end
