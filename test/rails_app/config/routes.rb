RailsApp::Application.routes.draw do
  resources :companies do
    get :next_step , :on => :member
  end

  resources :orders do
    get :next_step , :on => :member
  end
end
