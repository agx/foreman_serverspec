Rails.application.routes.draw do

  resources :serverspec_reports
  constraints(:id => /[^\/]+/) do
    resources :hosts do
      constraints(:host_id => /[^\/]+/) do
        resources :serverspec_reports, :only => [:index, :show]
      end
    end
  end

  namespace :api do
    scope "(:apiv)", :module => :v2, :defaults => {:apiv => 'v2'},
          :apiv => /v1|v2/, :constraints => ApiConstraints.new(:version => 2) do
      namespace :tests do

        resources :serverspec_reports, :except => [:new, :edit]
        post 'reports/', :to => 'serverspec#create'
        get  'serverspec_reports/', :to => 'serverspec#index'
      end
    end
  end
end

