Rails.application.routes.draw do

  # ERROR PAGES
  # ------------------------------------------------------------
  match '/403' => 'errors#403', via: :all
  match '/404' => 'errors#404', via: :all
  match '/406' => 'errors#406', via: :all
  match '/422' => 'errors#422', via: :all
  match '/500' => 'errors#500', via: :all
  
  # CONCERNS
  # ------------------------------------------------------------
  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end

  concern :sortable do 
    get '(sort/:sort)', :action => :index, :on => :collection
  end
  concern :dateable do 
    get '(date/:date)', :action => :index, :on => :collection
  end

  # USER routes
  # ------------------------------------------------------------
  devise_for :users
  resources :users, only: [:show]

  # COLLECTION routes
  # ------------------------------------------------------------
  resources :anthologies

  # WORKS routes
  # ------------------------------------------------------------
  resources :works, :concerns => [:sortable, :dateable, :paginatable] do
    
    # for new first chapters of stories
    get  'new-first-chapter' => "works/insertable_chapters#first", as: :first_chapter
    post 'new-first-chapter' => "works/insertables_chapters#create_first"

    # for new chapters in between existing chapters
    resources :chapters, :controller => 'works/chapters' do
      get  'insert-after' => "works/insertable_chapters#after", as: :insert
      post 'insert-after' => "works/insertable_chapters#create_after"
    end
    
    resources :notes, :controller => 'works/notes'
  end

  # - works subtypes
  scope module: 'works' do
    resources :stories
    resources :short_stories
    resources :external_stories
  end

  # - list works by related model
  get '/characters/:character_id/works'     => 'works#character_index',     as: :character_works
  get '/tags/:tag_id/works'                 => 'works#tag_index',           as: :tag_works
  get '/identities/:identity_id/works'      => 'works#identity_index',      as: :identity_works
  get '/identities/:identity_id/characters' => 'subjects/characters#identity_index', as: :identity_characters 

  # - work possessions
  resources :chapters, except: [:index, :new, :show], :controller => 'works/chapters'
  resources :notes,    except: [:index, :new, :show], :controller => 'works/notes'

  # SUBJECTS
  # ------------------------------------------------------------
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

  # DESCRIPTORS
  # ------------------------------------------------------------
  get 'tags' => 'descriptors#index'
  scope module: 'descriptors' do
    resources :activities
    resources :tags
    resources :identities
    resources :qualities
    resources :relators
  end
  
  # STATIC PAGES
  # ------------------------------------------------------------
  get 'help'  => 'static_pages#help'
  get 'about' => 'static_pages#about'
  root 'static_pages#home'
end
