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
  index_actions     = [:sortable, :dateable, :completeable,  :paginatable]
  work_simple_types = [:articles, :artwork,  :journals,      :music_videos, :records, :story_links]
  work_comp_types   = [:comics,   :stories,  :short_stories, :brachning_stories]
  work_types        = work_simple_types + work_comp_types

  get 'media/'        => 'mediums#index', as: :mediums
  get 'media/:medium' => 'mediums#show',  as: :all_media_by_medium

  resources :works, :concerns => index_actions

  work_types.each do |type|
    stype = type.to_s
    get '/' + stype + '/:id/about',   :action => :show, :controller => "works", as: stype.singularize + '_about'
  end

  # TYPES works types
  # ------------------------------------------------------------
  scope module: 'works' do
    work_simple_types.each do |type|
      resources type, :concerns => index_actions
    end

    work_types.each do |type|
      stype = type.to_s
      get '/' + stype + '/:id/discuss', :action => :show, :controller => "merged_discussions", as: stype.singularize + '_discussion'
    end

    # NARROW access
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    get '/works/:id/upcoming'   => 'upcoming#show',    as: :upcoming_work
    get '/works/:id/restricted' => 'restricted#show',  as: :restricted_work

    # NARROW narrative type
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    resources :fiction,    only: [:index], :concerns => index_actions
    resources :nonfiction, only: [:index], :concerns => index_actions

    # NARROW chaptered stories
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    get '/stories/:id/whole' => 'whole_story#show', as: :whole_story

    resources :stories, :concerns => index_actions do
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
    resources :branching_stories, :concerns => index_actions do
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

    # NARROW comic and comic pages
    resources :comics, :concerns => index_actions do
      resources :pages, controller: :comic_pages
    end

    # NARROW short stories
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    resources :short_stories, :concerns => [:sortable, :dateable, :paginatable] do
      resources :notes
    end

    # NARROW stats
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    curateables    = ['character', 'user', 'tag', 'work', 'identity']
    subcurateables = [
      ['cast-only',     'archetyped_in', 'cast'],
      ['as-mythos',     'as_mythos',     'general'],
      ['as-settings',   'as_setting',    'setting'],
      ['as-subjects',   'as_subject',    'subject'],
      ['as-references', 'as_reference',  'reference'],
    ]

    # NARROW curation controllers
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    scope module: 'curation' do
      (curateables - ['work']).each do |c|
        get '/' + c.pluralize + '/:' + c + '_id/works/' => c + '_works#index', as: c + '_works'
      end
      get '/works/:work_id/works' => 'works_intratags#index', as: :intratags
    
      work_types.each do |type|
        get '/' + type.to_s + '/:work_id/works' => 'works_intratags#index'
      end

      subcurateables.each do |sc|
        get '/works/:work_id/' + sc[0] + '-works' => 'works_intratags#index', as: 'work_' + sc[1], tagging_type: sc[2]
      end
    end

    to_about = ['_id/works/about',      'about_all_works#show']
    to_actvt = ['_id/works/activity',   'about_all_works#activity']
    to_atags = ['_id/works/about-tags', 'about_all_works#related']

    curateables.each do |c|
      get '/' + c.pluralize + '/:' + c + to_about[0] => to_about[1], as: c + '_work_about', tagger_table: c.pluralize
      get '/' + c.pluralize + '/:' + c + to_actvt[0] => to_actvt[1], as: c + '_work_actvt', tagger_table: c.pluralize
      get '/' + c.pluralize + '/:' + c + to_atags[0] => to_atags[1], as: c + '_work_atags', tagger_table: c.pluralize
    end

    subcurateables.each do |sc|
      get '/works/:work_id/' + sc[0] + to_about[0] => to_about[1], as: 'work_' + sc[1] +'_about', tagging_type: sc[2], tagger_table: 'works'
      get '/works/:work_id/' + sc[0] + to_actvt[0] => to_actvt[1], as: 'work_' + sc[1] +'_actvt', tagging_type: sc[2], tagger_table: 'works'
      get '/works/:work_id/' + sc[0] + to_atags[0] => to_atags[1], as: 'work_' + sc[1] +'_atags', tagging_type: sc[2], tagger_table: 'works'
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
  subject_types = ['characters', 'places', 'items', 'squads']

  scope module: 'subjects' do
    resources :clones, only: [:destroy]

    get   "/clones/:id/new" => "clones#new",   as: :assign_clone
    patch "/clones/:id/"    => "clones#create"

    post "/replicate/:id/" => "replicate#create", as: :replicate
    get  "/places/real"    => 'places#index',     as: :real_places,   reality_check: "real"
    get  "/places/unreal"  => 'places#index',     as: :unreal_places, reality_check: "unreal"
    
    subject_types.each do |s|
      resources s
    end

    scope module: 'curation' do
      get '/identities/:identity_id/characters' => 'identity_characters#index', as: :identity_characters
      get '/works/:work_id/characters'          => 'work_characters#index',     as: :work_characters
    end
  end

  # USER routes
  # ============================================================
  devise_for :users
  resources :users, only: [:show]
  resources :skins

  scope module: 'users' do
    resource :dashboard, only: [:show]
    resources :uploads,  only: [:index]

    uploadables = work_types.map{|t| t.to_s } - ['records', 'story_links'] + ['links', 'characters']
    uploadables.each do |u|
      get '/uploads/' + u, :action => :index, :controller => "uploads", resource_type: u, as: u + '_uploads'
    end
    
    resources :pen_namings do
      resource :switch, only: [:update], :controller => 'pen_switches'
    end
    get 'styles' => 'skins#index', as: :user_skins
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
