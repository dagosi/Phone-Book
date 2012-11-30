Phonebook::Application.routes.draw do

  # Defines the API.
  resources :contacts do
    resources :phones
  end
  
  # Defines the home page at '/'
  root :to => 'home#index'
end
