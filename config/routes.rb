Rails.application.routes.draw do



  get 'searches/search'
  root 'public/homes#top'
  get '/search', to: 'searches#search'

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admins, controllers: {
    sessions: "admin/sessions"
  }
  # 未認証の管理者がアクセスした際のリダイレクト先を指定
   unauthenticated :admin do
    root 'admin/sessions#new', as: :unauthenticated_admin_root
  end
  # 会員用
  # URL /customers/sign_in ...
  devise_for :customers, controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

# ゲストユーザー
  devise_scope :customer do
      post 'customers/guest_sign_in', to: 'public/sessions#guest_sign_in', as: :customers_guest_sign_in
  end
  # 会員側のルーティング
  namespace :public do

     #aboutページ

    get '/about', to: 'homes#about'

    

    # マイページ
    get 'mypage', to: 'customers#mypage', as: 'mypage'
    # ユーザー退会処理（ステータス更新）
    delete 'customers/withdraw', to: 'customers#withdraw', as: 'withdraw_customer'
    resources :customers,only: [:show, :edit, :update, :destroy]
    resources :posts, only: [:new, :create, :index, :show, :edit, :update, :destroy]do
      resources :post_comments, only: [:create,:destroy]
    end
    resource :session, only: [:new, :create, :destroy]
    
  end



  # 管理側のルーティング
  namespace :admin do
     root to: 'customers#index' # ログイン後のリダイレクト先を会員一覧に設定
    resources :customers, only: [:index, :show, :destroy,:edit, :update]
    resources :posts, only: [:index, :show, :destroy, :edit, :update] do
      resources :post_comments, only:[:destory]
    end
  end
end
 
