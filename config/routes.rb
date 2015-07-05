Rails.application.routes.draw do

  match '/403' => 'errors#403', via: :all
  match '/404' => 'errors#404', via: :all
  match '/406' => 'errors#406', via: :all
  match '/422' => 'errors#422', via: :all
  match '/500' => 'errors#500', via: :all
  
  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end

  concern :sortable do 
    get '(sort/:sort)', :action => :index, :on => :collection
  end
  concern :dateable do 
    get '(date/:date)', :action => :index, :on => :collection
  end

  devise_for :users
  resources :users, only: [:show]

  resources :anthologies
  resources :works, :concerns => [:sortable, :dateable, :paginatable] do
    
    get 'new-first-chapter'  => "works/insertable_chapters#first", as: :first_chapter
    post 'new-first-chapter' => "works/insertables_chapters#create_first"

    resources :chapters, :controller => 'works/chapters' do
      get 'insert-after'  => "works/insertable_chapters#after", as: :insert
      post 'insert-after' => "works/insertable_chapters#create_after"
    end
    
    resources :notes, :controller => 'works/notes'
  end

  # list works by related model
  get '/characters/:character_id/works'     => 'works#character_index',     as: :character_works
  get '/tags/:tag_id/works'                 => 'works#tag_index',           as: :tag_works
  get '/identities/:identity_id/works'      => 'works#identity_index',      as: :identity_works
  get '/identities/:identity_id/characters' => 'subjects/characters#identity_index', as: :identity_characters 

  resources :chapters, except: [:index, :new, :show], :controller => 'works/chapters'
  resources :notes,    except: [:index, :new, :show], :controller => 'works/notes'

  get 'subjects' => 'subjects#index'
  scope module: 'subjects' do
    resources :clones, only: [:edit, :update]
    post "/clones/:id/" => "clones#create", as: :replicate
    resources :characters
    resources :items
    resources :places do
      collection do 
        get :real
        get :unreal
      end
    end
  end

  get 'tags' => 'descriptors#index'
  scope module: 'descriptors' do
    resources :activities
    resources :tags
    resources :identities
    resources :qualities
    resources :relators
  end
  
  # static pages
  get 'help'  => 'static_pages#help'
  get 'about' => 'static_pages#about'
  root 'static_pages#home'
end
