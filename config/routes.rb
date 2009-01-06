ActionController::Routing::Routes.draw do |map|
  map.resources :assets
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.root :controller => 'assets'
end
