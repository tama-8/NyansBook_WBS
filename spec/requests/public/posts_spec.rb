# 投稿機能に関するテスト
require "rails_helper"
include Warden::Test::Helpers

RSpec.describe "Posts", type: :request do
  let!(:customer) { create(:customer) }
  let(:valid_attributes) do
    {
      content: "This is a valid test post",
      image: fixture_file_upload(Rails.root.join("spec/fixtures/files/test_image.png"), "image/png"),
       customer_id: customer.id
    }
  end

  let!(:invalid_attributes) do
    {
      content: "",  # content を空にしてバリデーションエラーを発生させる
      image: nil    # image を指定しないか、無効な値を設定
    }
  end
  #let(:post) { create(:post, customer: customer) }  # 適切なPostオブジェクトを定義
  # ログイン時にする
  # before do
  #   post customer_session_path, params: { customer: { email: customer.email, password: customer.password } }
  #   follow_redirect! # ログイン後のリダイレクトを追跡
  # end
  
  before do
    #Warden.test_mode!
    #login_as(customer, scope: :customer)
  end

  after do
    Warden.test_reset!
  end
  
  describe "#index" do
    context "ログインしたcustomerの場合" do
      before do
        Warden.test_mode!
        login_as(customer, scope: :customer)
      end
      it "200を返すこと" do
        get public_posts_url
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end
    
    context "未ログインの場合" do
      it "root_urlにリダイレクトされること" do
        get public_posts_url
        expect(response).to have_http_status "302"
        expect(response).to redirect_to new_customer_session_url
      end
    end
  end
  
  describe "#create" do
    context "ログインしたcustomerの場合" do
      before do
        Warden.test_mode!
        login_as(customer, scope: :customer)
      end
      
      it "createが成功したときshowにリダイレクトされること" do
        valid_attributes = FactoryBot.attributes_for(:valid_post)
        expect {
          post public_posts_url, params: { post: valid_attributes }
        }.to change(Post, :count).by(1)
        expect(flash[:notice]).to include "投稿成功しました"
        expect(response).to have_http_status "302"
        expect(response).to redirect_to public_post_url(Post.last)
      end
      
      it "createが失敗したときリダイレクトしないこと" do
        invalid_attributes = FactoryBot.attributes_for(:invalid_post)
        expect {
          post public_posts_url, params: { post: invalid_attributes }
        }.not_to change(Post, :count)
        expect(flash.now[:alert]).to include "投稿失敗しました: "
        expect(response).to have_http_status "200"
      end        
    end
    context "未ログインの場合" do
      it "root_urlにリダイレクトされること" do
        post public_posts_url
        expect(response).to have_http_status "302"
        expect(response).to redirect_to root_url
      end
    end
  end

  describe '投稿一覧画面のテスト' do
    before do
      
    # visit  new_customer_session_path
    # fill_in 'customer[email]', with: customer.email
    # fill_in 'customer[password]', with: customer.password
    # click_button 'Log in'
      #byebug
      #visit new_public_post_path
    end
    context '投稿成功のテスト' do
      before do
        
        #fill_in 'post[content]', with: Faker::Lorem.characters(number: 5)
        # fill_in 'book[body]', with: Faker::Lorem.characters(number: 20)
      end

      describe "POST /create" do
      # it "投稿詳細へ遷移すること" do
      # self.post public_posts_path, params: { post: valid_attributes }
        it 'リダイレクト先が、保存できた投稿の詳細画面になっている', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
          visit new_public_post_path
          fill_in 'post[content]', with: Faker::Lorem.characters(number: 5)
          click_button '投稿'
          expect(current_path).to eq '/public/posts/' + Post.last.id.to_s
            # expect(current_path).to eq '/public/posts/new'
            # is_expected.to eq '/public/posts/' + post.id.to_s
           
        end
          # expect(response).to redirect_to(public_posts_path(Post.last))
          
        # end
      end
    end
    describe "POST /create with invalid data" do
      it "バリデーションエラーメッセージが表示されること" do
        post public_posts_path, params: { post: invalid_attributes }
        expect(response.body).to include("投稿失敗しました") # バリデーションエラーメッセージを確認
      end
    end
end



describe "投稿編集" do
  context "編集ページへの遷移" do
    it "編集ページが表示されること" do
      get edit_public_post_path(post)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("") # 編集ページに含まれる内容を確認
    end
  end
end
context "投稿を更新する場合" do
  it "投稿詳細へ遷移すること" do
     # まず、投稿を作成する
    post public_posts_path, params: { post: { content: "Test content",customer_id: customer.id } }
     # 正しいパラメータ形式で呼び出しを行う
    patch public_post_path(Post.last), params: { post: { content: "Updated content" } }
    expect(response).to redirect_to(post_path(Post.last))  # 新しい投稿の詳細ページにリダイレクトされることを確認
    follow_redirect!  # リダイレクト先のページを取得
    expect(response.body).to include("Test content")  # 作成した投稿の内容が詳細ページに含まれているか確認
  end
end

context "投稿を削除する場合" do
  it "マイページへ遷移し、削除が反映されていること" do
    delete public_post_path(post)
    expect(response).to redirect_to public_customer_path(customer)
    follow_redirect!
    expect(response.body).to include("投稿が削除されました")  # フラッシュメッセージが表示されていることを確認
    expect(response.body).not_to include(post.content)  # 削除された投稿の内容が表示されていないことを確認
  end
 end
end
