Rails.application.routes.draw do

  # ERROR PAGES
  # ============================================================
  match '/403' => 'errors#403', via: :all
  match '/404' => 'errors#404', via: :all
  match '/406' => 'errors#406', via: :all
  match '/422' => 'errors#422', via: :all
  match '/500' => 'errors#500', via: :all
  
  # CONCERNS
  # ============================================================
  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end

  concern :sortable do 
    get '(sort/:sort)', :action => :index, :on => :collection
  end

  concern :dateable do 
    get '(date/:date)', :action => :index, :on => :collection
  end

  concern :completeable do 
    get '(completion/:completion)', :action => :index, :on => :collection
  end

  # USER routes
  # ============================================================
  devise_for :users
  resources :users, only: [:show]
  resources :skins

  scope module: 'users' do
    resource :dashboard, only: [:show]
    resources :pen_namings do
      resource :switch, only: [:update], :controller => 'pen_switches'
    end
    get  'styles' => 'skins#index', as: :user_skins
  end

  # ADMIN routes
  # ============================================================
  scope module: 'admin' do
    resource :control, only: [:show]
  end

  # Interaction routes
  # ============================================================
  resources :comments

  # COLLECTION routes
  # ============================================================
  resources :anthologies

  # WORKS routes
  # ============================================================
  resources :works, :concerns => [:sortable, :dateable, :completeable, :paginatable]

  # TYPES works types
  # ------------------------------------------------------------
  scope module: 'works' do

    resources :articles,    :concerns => [:sortable, :dateable, :completeable, :paginatable]
    resources :story_links, :concerns => [:sortable, :dateable, :completeable, :paginatable]

    # NARROW narrative type
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    resources :fiction,    only: [:index], :concerns => [:sortable, :dateable, :completeable, :paginatable]
    resources :nonfiction, only: [:index], :concerns => [:sortable, :dateable, :completeable, :paginatable]

    # NARROW stories
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    get '/stories/:id/whole' => 'whole_story#show', as: :whole_story
    resources :stories, :concerns => [:sortable, :dateable, :completeable, :paginatable] do
      resources :notes
      resources :chapters
    end

    # NARROW chapters
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    scope module: 'chapters' do
      # INSERT first
      # ............................................................
      get  'stories/:story_id/new-first' => 'first#new', as: :first_chapter
      post 'stories/:story_id/new-first' => "first#create"

      # INSERT first
      # ............................................................
      get  'chapters/:chapter_id/new-next' => "next#new", as: :insert_chapter
      post 'chapters/:chapter_id/new-next' => "next#create"
    end

    # NARROW short stories
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    resources :short_stories, :concerns => [:sortable, :dateable, :completeable, :paginatable] do
      resources :notes
    end

    # NARROW curation controllers
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    scope module: 'curation' do
      get '/characters/:character_id/works'     => 'character_works#index',     as: :character_works
      get '/tags/:tag_id/works'                 => 'tag_works#index',           as: :tag_works
      get '/identities/:identity_id/works'      => 'identity_works#index',      as: :identity_works
    end
  end
  

  # TYPE work elements
  # ------------------------------------------------------------
  resources :chapters, except: [:index, :new, :show], :controller => 'works/chapters'
  resources :notes,    except: [:index, :new, :show], :controller => 'works/notes'

  # SUBJECTS
  # ============================================================
  get 'subjects' => 'subjects#index'
  scope module: 'subjects' do
    resources :clones, only: [:edit, :update]
    post "/clones/:id/"   => "clones#create", as: :replicate
    get  "/places/real"   => 'real_places#index',   as: :real_places
    get  "/places/unreal" => 'unreal_places#index', as: :unreal_places
    
    resources :characters
    resources :items
    resources :places

    scope module: 'curation' do
      get '/identities/:identity_id/characters' => 'identity_characters#index', as: :identity_characters
    end
  end

  # TAGS & CATEGORIES
  # ============================================================
  get 'all_tags' => 'taggings#show'

  scope module: 'taggings' do
    resources :activities, except: [:new, :create]
    resources :tags,       except: [:new, :create]
    resources :identities, except: [:new, :create]
    resources :qualities,  except: [:new, :create]
    resources :relators
  end

  scope module: 'categories' do
    resources :creator_categories
    resources :facets
  end
  
  # STATIC PAGES
  # ============================================================
  get 'help'  => 'static_pages#help'
  get 'about' => 'static_pages#about'
  root 'static_pages#home'

end
