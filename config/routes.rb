Rails.application.routes.draw do
  namespace :admin do
    get "reports/index"
  end
  # get 'chats/show'
  get "searches/search"
  root "public/homes#top"
  get "/search", to: "searches#search"

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admins, path: "admin", controllers: {
    sessions: "admin/sessions"
  }, path_names: { sign_in: "" }
  # 未認証の管理者がアクセスした際のリダイレクト先を指定
  unauthenticated :admin do
    root "admin/sessions#new", as: :unauthenticated_admin_root
  end

  # 会員用
  # URL /customers/sign_in ...
  devise_for :customers, controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  # ゲストユーザー
  devise_scope :customer do
    post "customers/guest_sign_in", to: "public/sessions#guest_sign_in", as: :customers_guest_sign_in
  end

  # 会員側のルーティング
  namespace :public do
    # aboutページ
    get "/about", to: "homes#about"
    # マイページ
    get "mypage", to: "customers#mypage", as: "mypage"
    # ユーザー退会処理（ステータス更新）
    delete "customers/withdraw", to: "customers#withdraw", as: "withdraw_customer"
    resources :customers, only: [:show, :edit, :update, :destroy] do
      member do
        get :following, :followers
      end
      resource :relationships, only: [:create, :destroy]
    end
    resources :posts, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
      resources :post_comments, only: [:create, :destroy]
      resource :favorite, only: [:create, :destroy]
      collection do
        get :favorites  # 自分がいいねした投稿一覧ページ
      end
    end
    resources :chats, only: [:create, :show, :destroy] do
      delete :destroy_all, on: :collection
    end
    # チャット通知
    resources :notifications, only: [:index] do
      member do
        patch :mark_as_read
      end
      collection do
        patch :mark_all_as_read
      end
    end
    resource :session, only: [:new, :create, :destroy]
    resources :relationships, only: [:create, :destroy]
    resources :reports, only: [:new, :create]
  end

  # 管理側のルーティング
  namespace :admin do
    # root to: "customers#index" # ログイン後のリダイレクト先を会員一覧に設定
    get "dashboard", to: "dashboard#index"
    resources :customers, only: [:index, :show, :destroy, :edit, :update]
    resources :posts, only: [:index, :show, :destroy, :edit, :update]
    resources :post_comments, only: [:index, :destroy]
    resources :reports, only: [:index, :show, :destroy] do
     member do
       delete :delete_content
       patch :ignore
       patch :toggle
     end
   end
  end
end
