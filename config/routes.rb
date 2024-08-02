Rails.application.routes.draw do
  devise_for :users ,controllers: {
    registrations: 'users/registrations'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # 会員側のルーティング
  namespace :public do
    # トップページとアバウトページ
    root 'homes#top'  
    get '/about', to: 'homes#about'
    #ゲストユーザー
    devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in",as: :users_guest_sign_in
    end
    # マイページ
    get 'mypage', to: 'users#mypage', as: 'mypage'
    # ユーザー退会処理（ステータス更新）
    patch 'users/withdraw', to: 'users#withdraw', as: 'withdraw_user'
    resources :users, only: [:show, :edit, :update] do
      member do
        # ユーザー詳細
        get :show
        # ユーザー編集
        get :edit
        # ユーザー更新処理
        patch :update
      end
    end
  end

  # 管理側のルーティング
#   namespace :admin do
#     root 'homes#top'  # 管理側のトップページ
#     resources :users, only: [:index, :show, :edit, :update, :destroy]
#     resources :posts, only: [:index, :show, :destroy]
#     resources :comments, only: [:index, :show, :destroy]
#     resources :reports, only: [:index, :show, :update]
#     # その他の管理側ルーティングをここに記述
#   end

  # その他のルーティング...
end