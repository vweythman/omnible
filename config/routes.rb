Rails.application.routes.draw do

  # ERROR PAGES
  # ============================================================
  match '/403' => 'errors#e403', via: :all
  match '/404' => 'errors#e404', via: :all
  match '/406' => 'errors#e406', via: :all
  match '/422' => 'errors#e422', via: :all
  match '/500' => 'errors#e500', via: :all
  
  # CONCERNS
  # ============================================================
  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end

  concern :sortable do 
    get '(sort/:sort)', :action => :index, :on => :collection, :as => :sorted
  end

  concern :dateable do 
    get '(date/:date)', :action => :index, :on => :collection, :as => :dated
  end

  concern :completeable do 
    get '(completion/:completion)', :action => :index, :on => :collection, as: :stateful
  end

  # USER routes
  # ============================================================
  devise_for :users
  resources :users, only: [:show]
  resources :skins

  scope module: 'users' do
    resource :dashboard, only: [:show]
    resources :uploads,  only: [:index]

    namespace :uploads do
      resources :articles,      only: [:show, :index]
      resources :characters,    only: [:show, :index]
      resources :items,         only: [:show, :index]
      resources :links,         only: [:show, :index]
      resources :places,        only: [:show, :index]
      resources :short_stories, only: [:show, :index]
      resources :stories,       only: [:show, :index]
    end

    resources :pen_namings do
      resource :switch, only: [:update], :controller => 'pen_switches'
    end
    get 'styles' => 'skins#index', as: :user_skins
  end

  # ADMIN routes
  # ============================================================
  scope module: 'admin' do
    resource :control, only: [:show]
    get 'admin' => 'controls#show', as: :admin
  end

  # Interaction routes
  # ============================================================
  resources :comments
  get '/comments/:id/respond' => 'comments#new', as: :comment_on_comment

  # COLLECTION routes
  # ============================================================
  resources :anthologies

  # WORKS routes
  # ============================================================
  resources :works, :concerns => [:sortable, :dateable, :completeable, :paginatable]

  # TYPES works types
  # ------------------------------------------------------------
  scope module: 'works' do
    work_simple_types = [:records, :articles, :journals, :story_links]
    work_types        = [:articles, :brachning_stories, :journals, :records, :short_stories, :stories, :story_links]

    work_simple_types.each do |type|
      resources type, :concerns => [:sortable, :dateable, :completeable, :paginatable]
    end

    work_types.each do |type|
      get '/' + type.to_s + '/:id/discuss', :action => :show, :controller => "merged_discussions", as: type.to_s.singularize + '_discussion'
    end

    # NARROW access
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    get '/works/:id/upcoming'   => 'upcoming#show',    as: :upcoming_work
    get '/works/:id/restricted' => 'restricted#show',  as: :restricted_work

    # NARROW narrative type
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    resources :fiction,    only: [:index], :concerns => [:sortable, :dateable, :completeable, :paginatable]
    resources :nonfiction, only: [:index], :concerns => [:sortable, :dateable, :completeable, :paginatable]

    # NARROW chaptered stories
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    get '/stories/:id/whole' => 'whole_story#show', as: :whole_story

    resources :stories, :concerns => [:sortable, :dateable, :completeable, :paginatable] do
      resources :chapters
      resources :notes
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

    # NARROW branching stories
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    resources :branching_stories, :concerns => [:sortable, :dateable, :completeable, :paginatable] do
      resources :branches, except: [:new, :create]
      resource  :discuss,  only: [:show], :controller => "merged_discussions"
    end

    scope module: 'branches' do
      get  'branches/:branch_id/bubble' => 'bubblings#new', as: :branch_bubble
      post 'branches/:branch_id/bubble' => "bubblings#create"
      
      get  'branches/:branch_id/graft' => 'graftings#new', as: :graft_branch
      post 'branches/:branch_id/graft' => "graftings#create"

      resources :branchings, only: [:edit, :update, :destroy]
    end

    # NARROW short stories
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    resources :short_stories, :concerns => [:sortable, :dateable, :paginatable] do
      resources :notes
    end

    # NARROW curation controllers
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    scope module: 'curation' do
      get '/characters/:character_id/works' => 'character_works#index', as: :character_works
      get '/users/:user_id/works'           => 'user_works#index',      as: :user_works
      get '/tags/:tag_id/works'             => 'tag_works#index',       as: :tag_works
      get '/identities/:identity_id/works'  => 'identity_works#index',  as: :identity_works
      get '/works/:work_id/works'           => 'works_intratags#index', as: :intratags

      work_types.each do |type|
        get '/' + type.to_s + '/:work_id/works' => 'works_intratags#index'
      end

      scope module: 'intratags' do
        ([:works] + work_types).each do |type|
          get '/' + type.to_s + '/:work_id/works-with-cast' => 'cast#index',      as: type.to_s + '_archetyped_in'
          get '/' + type.to_s + '/:work_id/as-mythos'       => 'general#index',   as: type.to_s + '_as_mythos'
          get '/' + type.to_s + '/:work_id/as-setting'      => 'setting#index',   as: type.to_s + '_as_setting'
          get '/' + type.to_s + '/:work_id/as-subject'      => 'subject#index',   as: type.to_s + '_as_subject'
          get '/' + type.to_s + '/:work_id/as-reference'    => 'reference#index', as: type.to_s + '_as_reference'
        end
      end
    end
  end

  # TYPE work elements
  # ------------------------------------------------------------
  work_elements = [:chapters, :notes, :branches]
  work_elements.each do |type|
    resources type, except: [:index, :new, :show], :controller => 'works/' + type.to_s
    get '/' + type.to_s + '/:id/discuss', :action => :show, :controller => "discussions", as: type.to_s.singularize + '_discussion'
  end

  # SUBJECTS
  # ============================================================
  get 'subjects' => 'subjects#index'
  scope module: 'subjects' do
    resources :clones, only: [:new, :create, :destroy]

    post "/replicate/:id/" => "replicate#create",    as: :replicate
    get  "/places/real"    => 'real_places#index',   as: :real_places
    get  "/places/unreal"  => 'unreal_places#index', as: :unreal_places
    
    resources :characters
    resources :items
    resources :places

    scope module: 'curation' do
      get '/identities/:identity_id/characters' => 'identity_characters#index', as: :identity_characters
      get '/works/:work_id/characters'          => 'work_characters#index',     as: :work_characters
    end
  end

  # TAGS & CATEGORIES
  # ============================================================
  get 'all_tags' => 'taggings#show'

  scope module: 'taggings' do
    resources :tags,       except: [:new, :create]
    resources :identities, except: [:new, :create]
    resources :qualities,  except: [:new, :create]
    resources :relators
  end

  scope module: 'categories' do
    resources :creator_categories
    resources :work_categories, only: [:index, :show]
    resources :facets
    post   'agentize/:describer_id/:creator_id' => "agentize#create",  as: :create_agent
    delete 'agentize/:describer_id/:creator_id' => "agentize#destroy", as: :destroy_agent
  end
  
  # STATIC PAGES
  # ============================================================
  get 'help'  => 'static_pages#help'
  get 'about' => 'static_pages#about'
  root 'static_pages#home'

end
