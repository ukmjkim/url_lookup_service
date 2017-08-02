Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :urlinfos do
  end
  get 'urlinfo', to: 'urlinfos#index'
  get 'urlinfo/:requested_by', to: 'urlinfos#index'
  get 'urlinfo/:requested_by/', to: 'urlinfos#index'
  get 'urlinfo/:requested_by/:domain_name(/:query_string)' => 'urlinfos#find_by_url', constraints: {
    :domain_name => /[^\/]+/,
    :query_string => /[^\/]+/
  }

  post 'urlinfo/:requested_by/:domain_name(/:query_string)', to: 'urlinfos#create_by_url', constraints: {
    :domain_name => /[^\/]+/,
    :query_string => /[^\/]+/
  }

  delete 'urlinfo/:requested_by/:domain_name(/:query_string)', to: 'urlinfos#delete_by_url', constraints: {
    :domain_name => /[^\/]+/,
    :query_string => /[^\/]+/
  }
end
