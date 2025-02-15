Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  #Googleカレンダーのイベントを取得
  get 'schedules/events', to: 'schedules#events'

  #token認証/user登録ルート
  post 'google_oauth', to: 'oauth#google_oauth'

  #リアル日記のルート
  resources :realdiaries, only: [:index, :show, :create]
  #未来日記のルート
  resources :futurediaries, only: [:index, :show]


  # Defines the root path route ("/")
  # root "posts#index"
end
