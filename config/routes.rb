Rails.application.routes.draw do

  get 'journals/show'

  get 'journals/edit'

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

  # Interaction routes
  # ------------------------------------------------------------
  resources :comments

  # COLLECTION routes
  # ------------------------------------------------------------
  resources :anthologies

  # WORKS routes
  # ------------------------------------------------------------
  resources :works, :concerns => [:sortable, :dateable, :paginatable]

  # - work types
  scope module: 'works' do

    # sort by narrative type
    resources :fiction,    only: [:index], :concerns => [:sortable, :dateable, :paginatable]
    resources :nonfiction, only: [:index], :concerns => [:sortable, :dateable, :paginatable]

    # get stories
    get '/stories/:id/whole' => 'whole_story#show', as: :whole_story
    resources :stories do
      resources :notes
      resources :chapters
    end

    # place chapters
    scope module: 'chapters' do
      # new first chapters
      get  'stories/:story_id/new-first' => 'first#new', as: :first_chapter
      post 'stories/:story_id/new-first' => "first#create"

      # new chapter inbetween old chapters
      get  'chapters/:chapter_id/new-next' => "next#new", as: :insert_chapter
      post 'chapters/:chapter_id/new-next' => "next#create"
    end

    resources :short_stories do
      resources :notes
    end

    resources :articles
    resources :story_records

    # - list works by related model
    scope module: 'curation' do
      get '/characters/:character_id/works'     => 'character_works#index',     as: :character_works
      get '/tags/:tag_id/works'                 => 'tag_works#index',           as: :tag_works
      get '/identities/:identity_id/works'      => 'identity_works#index',      as: :identity_works
    end
  end
  

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

    scope module: 'curation' do
      get '/identities/:identity_id/characters' => 'identity_characters#index', as: :identity_characters
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
