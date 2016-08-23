Rails.application.routes.draw do

  # TABLE OF CONTENTS
  # ############################################################
  # 1 -- SETUP
  # 1.1 -- CONCERNS
  # 1.2 -- VARIABLES
  # 2 -- ROUTES
  # 2.1 -- ERRORS
  # 2.2 -- USERS
  # 2.2.1 -- GENERAL
  # 2.2.2 -- ADMIN DASHBOARD
  # 2.2.3 -- USER DASHBOARD
  # 2.3 -- UPLOADS
  # 2.3.1 -- GENERAL
  # 2.3.3 -- SUBJECTS
  # 2.3.3 -- WORKS
  # 2.3.3.1 -- GENERAL
  # 2.3.3.2 -- DETAILED
  # 2.3.3.2.1 -- INDEXING
  # 2.3.3.2.2 -- FICTION
  # 2.3.3.2.2.1 -- CHAPTERED STORIES
  # 2.3.3.2.2.2 -- BRANCHING STORIES
  # 2.3.3.2.2.3 -- OTHER FICTION
  # 2.3.3.2.3 -- TYPES
  # 2.4 -- TAGS & CATEGORIES
  # 2.5 -- STATIC PAGES
  # 2.5.1 -- GUIDES
  # 2.5.1 -- ROOT
  # ############################################################

  # ############################################################
  # 1 -- SETUP
  # ############################################################
  # 1.1 -- CONCERNS
  # 1.2 -- VARIABLES
  # ############################################################
  # 1.1 -- SETUP :: CONCERNS
  # ============================================================
  concern :completeable do 
    get '(completion/:completion)', action: :index, on: :collection, as: :stateful
  end

  concern :dateable do 
    get '(date/:date)', action: :index, on: :collection, as: :dated
  end

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  concern :sortable do 
    get '(sort/:sort)', action: :index, on: :collection, as: :sorted
  end

  # 1.2 -- SETUP :: VARIABLES
  # ============================================================
  subject_types   = [
    'characters',
    'places',
    'items',
    'squads'
  ]
  work_singletons = [
    'articles',
    'artwork',
    'music_videos',
    'poems',
    'records',
    'work_links'
  ]
  work_multiples  = [
    'comics',
    'branching_stories',
    'journals',
    'short_stories',
    'stories'
  ]
  work_elements   = [
    'chapters',
    'notes',
    'branches'
  ]
  all_acts_as_tag = [
    'character',
    'identity',
    'tag',
    'user',
    'work'
  ]

  taggable_work_types = [
    ['cast-only',     'archetyped_in', 'cast'],
    ['as-mythos',     'as_mythos',     'general'],
    ['as-settings',   'as_setting',    'setting'],
    ['as-subjects',   'as_subject',    'subject'],
    ['as-references', 'as_reference',  'reference'],
  ]

  index_concerns = [:sortable, :dateable, :completeable, :paginatable]
  all_work_types = work_singletons + work_multiples
  uploadables    = all_work_types  - ['records', 'work_links'] + ['links', 'characters', 'works']

  # ############################################################
  # 2 -- ROUTES
  # ############################################################
  # 2.1 -- ERRORS
  # 2.2 -- USERS
  # 2.3 -- UPLOADS
  # 2.4 -- TAGS & CATEGORIES
  # 2.5 -- STATIC PAGES
  # ############################################################
  # 2.1 -- ROUTES :: ERRORS
  # ============================================================
  match '/403' => 'errors#e403', via: :all
  match '/404' => 'errors#e404', via: :all
  match '/406' => 'errors#e406', via: :all
  match '/422' => 'errors#e422', via: :all
  match '/500' => 'errors#e500', via: :all

  # 2.2 -- ROUTES :: USERS
  # ============================================================
  # 2.2.1 -- GENERAL
  # 2.2.2 -- ADMIN DASHBOARD
  # 2.2.3 -- USER DASHBOARD
  # ============================================================
  # 2.2.1 -- ROUTES :: USERS :: GENERAL
  # ------------------------------------------------------------
  devise_for :users

  resources  :users, only: [:show]
  resources  :comments

  get '/comments/:id/respond' => 'comments#new', as: :comment_on_comment

  # 2.2.2 -- ROUTES :: USERS :: ADMIN DASHBOARD
  # ------------------------------------------------------------
  scope module: :admin do
    get 'admin' => 'controls#show', as: :admin
  end

  # 2.2.3 -- ROUTES :: USERS :: USER DASHBOARD
  # ------------------------------------------------------------
  scope module: :users do
    resource  :dashboard, only: [:show]
    resources :uploads,   only: [:index]

    resources :pen_namings do
      resource :switch, only: [:update], controller: 'pen_switches'
    end 

    get 'styles' => 'skins#index', as: :style_uploads

    uploadables.each do |type|
      get '/uploads/' + type, action: :index, controller: "uploads", resource_type: type, as: type.singularize + '_uploads'
    end  
  end

  # 2.3 -- ROUTES :: UPLOADS
  # ============================================================
  # 2.3.1 -- GENERAL
  # 2.3.3 -- SUBJECTS
  # 2.3.3 -- WORKS
  # ============================================================
  # 2.3.1 -- ROUTES :: UPLOADS :: GENERAL
  # ------------------------------------------------------------
  get 'media/'        => 'mediums#index', as: :mediums
  get 'media/:medium' => 'mediums#show',  as: :all_media_by_medium

  resources :anthologies
  resources :skins

  # 2.3.3 -- SUBJECTS
  # ------------------------------------------------------------
  get 'subjects' => 'subjects#index'

  scope module: :subjects do
    subject_types.each do |s|
      resources s
    end

    resources :clones, only: [:destroy]

    get   "/clones/:id/new" => "clones#new",   as: :assign_clone
    patch "/clones/:id/"    => "clones#create"

    post "/replicate/:id/" => "replicate#create", as: :replicate
    get  "/places/real"    => 'places#index',     as: :real_places,   reality_check: "real"
    get  "/places/unreal"  => 'places#index',     as: :unreal_places, reality_check: "unreal"
    
    get '/identities/:identity_id/characters' => 'curation/identity_characters#index', as: :identity_characters
    get '/works/:work_id/characters'          => 'curation/work_characters#index',     as: :work_characters
  end

  # 2.3.3 -- ROUTES :: UPLOADS :: WORKS
  # ------------------------------------------------------------
  # 2.3.3.1 -- GENERAL
  # 2.3.3.2 -- DETAILED
  # ------------------------------------------------------------
  # 2.3.3.1 -- ROUTES :: UPLOADS :: WORKS :: GENERAL
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  resources :works, concerns: index_concerns

  all_work_types.each do |type|
    resources :notes
    get '/' + type + '/:id/about',   action: :show, controller: "works",              as: type.singularize + '_about'
    get '/' + type + '/:id/discuss', action: :show, controller: "merged_discussions", as: type.singularize + '_discussion'
  end

  work_elements.each do |type|
    resources type, except: [:index, :new, :show], controller: 'works/' + type
    get '/' + type + '/:id/discuss', action: :show, controller: "discussions", as: type.singularize + '_discussion'
  end

  # 2.3.3.2 -- ROUTES :: UPLOADS :: WORKS :: DETAILED
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # 2.3.3.2.1 -- INDEXING
  # 2.3.3.2.2 -- FICTION
  # 2.3.3.2.3 -- TYPES
  # 2.3.3.2.4 -- FIND BY TAGS
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  scope module: :works do

    # 2.3.3.2.1 -- ROUTES :: UPLOADS :: WORKS :: INDEXING
    # **********************************************************
    resources :fiction,    only: [:index], concerns: index_concerns
    resources :nonfiction, only: [:index], concerns: index_concerns

    to_about = ['_id/works/about',      'about_all_works#show']
    to_actvt = ['_id/works/activity',   'about_all_works#activity']
    to_atags = ['_id/works/about-tags', 'about_all_works#related']

    all_acts_as_tag.each do |tag_type|
      get "/#{tag_type.pluralize}/:#{tag_type}_id/works/" => "curation/#{tag_type}_works#index", as: tag_type + '_works'
    end

    all_acts_as_tag.each do |c|
      path_start = "/#{c.pluralize}/:#{c}"
      get path_start + to_about[0] => to_about[1], as: c + '_works_about',      tagger_table: c.pluralize
      get path_start + to_actvt[0] => to_actvt[1], as: c + '_works_activity',   tagger_table: c.pluralize
      get path_start + to_atags[0] => to_atags[1], as: c + '_works_about_tags', tagger_table: c.pluralize
    end

    all_work_types.each do |type|
      get '/' + type + '/:work_id/works' => 'curation/works_intratags#index'
    end

    taggable_work_types.each do |tag_type|
      get '/works/:work_id/' + tag_type[0] + '-works' => 'curation/works_intratags#index', as: 'work_' + tag_type[1], tagging_type: tag_type[2]
    end

    taggable_work_types.each do |sc|
      path_start = "/works/:work_id/#{sc[0]}"
      get path_start + to_about[0] => to_about[1], as: 'work_' + sc[1] +'_about',      tagging_type: sc[2], tagger_table: 'works'
      get path_start + to_actvt[0] => to_actvt[1], as: 'work_' + sc[1] +'_activity',   tagging_type: sc[2], tagger_table: 'works'
      get path_start + to_atags[0] => to_atags[1], as: 'work_' + sc[1] +'_about_tags', tagging_type: sc[2], tagger_table: 'works'
    end

    # 2.3.3.2.2 -- ROUTES :: UPLOADS :: WORKS :: FICTION
    # **********************************************************
    # 2.3.3.2.2.1 -- CHAPTERED STORIES
    # 2.3.3.2.2.2 -- BRANCHING STORIES
    # 2.3.3.2.2.3 -- COMICS
    # **********************************************************
    # 2.3.3.2.2.1 -- ROUTES :: UPLOADS :: WORKS :: FICTION :: CHAPTERED STORIES
    # ..........................................................
    resources :stories, concerns: index_concerns do
      resources :chapters
      resources :notes
    end

    get '/stories/:id/whole' => 'whole_story#show', as: :whole_story

    scope module: 'chapters' do
      get  'stories/:story_id/new-first'   => 'first#new', as: :first_chapter
      get  'chapters/:chapter_id/new-next' => "next#new",  as: :insert_chapter

      post 'stories/:story_id/new-first'   => "first#create"
      post 'chapters/:chapter_id/new-next' => "next#create"
    end

    # 2.3.3.2.2.2 -- ROUTES :: UPLOADS :: WORKS :: FICTION :: BRANCHING STORIES
    # ..........................................................
    resources :branching_stories, concerns: index_concerns do
      resources :branches, except: [:new, :create]
    end

    scope module: 'branches' do
      resources :branchings, only: [:edit, :update, :destroy]

      get  'branches/:branch_id/bubble' => 'bubblings#new', as: :branch_bubble
      get  'branches/:branch_id/graft'  => 'graftings#new', as: :graft_branch
      
      post 'branches/:branch_id/bubble' => "bubblings#create"
      post 'branches/:branch_id/graft'  => "graftings#create"
    end

    # 2.3.3.2.2.3 -- ROUTES :: UPLOADS :: WORKS :: FICTION :: OTHER FICTION
    # ..........................................................
    resources :comics, concerns: index_concerns do
      resources :pages, controller: :comic_pages
    end

    resources :short_stories, concerns: index_concerns do
      resources :notes
    end

    # 2.3.3.2.3 -- ROUTES :: UPLOADS :: WORKS :: TYPES
    # **********************************************************
    work_singletons.each do |type|
      resources type, concerns: index_concerns
    end

    resources :journals, :concerns => index_concerns do
      resources :articles, only: [:show, :index], controller: "journals/articles"
      resources :notes
    end
  end # END MODULE WORKS SCOPE

  # 2.4 -- ROUTES :: TAGS & CATEGORIES
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

  # 2.5 -- ROUTES :: STATIC PAGES
  # ============================================================
  # 2.5.1 -- ROUTES :: STATIC PAGES :: GUIDES
  # ------------------------------------------------------------
  get 'help'  => 'static_pages#help'
  get 'about' => 'static_pages#about'

  # 2.5.2 -- ROUTES :: STATIC PAGES :: ROOT
  # ------------------------------------------------------------
  root 'static_pages#home' 

end
