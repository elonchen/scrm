SCRM::Application.routes.draw do

  resources :departments

  resources :navigations

  mount Ckeditor::Engine => '/ckeditor'
  resources :faqs

  resources :system_configs

  resources :zones

  resources :bank_accounts

  resources :orders do
    match 'close', via: [:put, :patch], on: :member
  end
  resources :ddb_accounts

  resources :products

  resources :people

  resources :items, only: [:index, :show] do
    collection do
      get 'statistics'
      post 'export'
    end
  end

  resources :stock_items, controller: 'items', type: 'StockItem', only: [:index, :show, :new, :create] do
    member do
      match "cancel", via: [:put, :patch]
      match "accept", via: [:put, :patch]
      match "reject", via: [:put, :patch]
    end
    collection do
      post 'import'
    end
  end
  resources :sale_items, controller: 'items', type: 'SaleItem', only: [:index, :show, :new, :create] do
    member do
      match "cancel", via: [:put, :patch]
      match "accept", via: [:put, :patch]
      match "reject", via: [:put, :patch]
    end
    collection do
      post 'import'
    end
  end

  root to: 'activities#index'

  resources :activities, only: [:index, :show]

  devise_for :members,:path_names => {
    :sign_in => 'login',
    :sign_out => 'logout',
    :registration => 'register'}, controllers: {:sessions=>'sessions', :registrations=>'registrations'}

  resources :members
  resources :customers do
    resources :communication_notes, controller: 'notes', type: 'CommunicationNote', only: [:index, :show, :new, :create, :edit, :update]
    resources :visit_notes, controller: 'notes', type: 'VisitNote', only: [:index, :show, :new, :create, :edit, :update]
    resources :notes, only: [:index, :show]
    collection do
      post :import
    end
  end

  resources :alarms, only:[] do
    member do
      post :close
    end
  end

  resources :notes, only:[] do
    collection do
      get :statistics
      get :statistics_by_day
    end
  end

end
