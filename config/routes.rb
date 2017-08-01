Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :urlinfos do
  end
  get 'urlinfo', to: 'urlinfos#index'
  get 'urlinfo/1', to: 'urlinfos#index'
  get 'urlinfo/1/:domain_name/:query_string' => 'urlinfos#find_by_url', constraints: {
    :domain_name => /[^\/]+/,
    :query_string => /[^\/]+/
  }

  post 'urlinfo/1/:domain_name/:query_string', to: 'urlinfos#create_by_url'
  delete 'urlinfo/1/:domain_name/:query_string', to: 'urlinfos#delete_by_url'
end
