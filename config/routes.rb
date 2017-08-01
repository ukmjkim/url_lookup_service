Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :urlinfos do
  end
  get 'urlinfo/1' => 'urlinfos#index'
  get 'urlinfo/1/:domain_name/:query_string' => 'urlinfos#show'
  post 'urlinfo/1/:domain_name/:query_string' => 'urlinfos#post'
  delete 'urlinfo/1/:domain_name/:query_string' => 'urlinfos#delete'
end
