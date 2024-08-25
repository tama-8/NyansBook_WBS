# 投稿機能に関するテスト
require "rails_helper"
include Warden::Test::Helpers

RSpec.describe "Posts", type: :request do
  let(:customer) { create(:customer) }
  let(:valid_attributes) do
    {
      content: "This is a valid test post",
      image: fixture_file_upload(Rails.root.join("spec/fixtures/files/test_image.png"), "image/png")
    }
  end

  let!(:invalid_attributes) do
    {
      content: "",  # content を空にしてバリデーションエラーを発生させる
      image: nil    # image を指定しないか、無効な値を設定
    }
  end
  let(:post) { create(:post, customer: customer) }  # 適切なPostオブジェクトを定義
  # ログイン時にする
  # before do
  #   post customer_session_path, params: { customer: { email: customer.email, password: customer.password } }
  #   follow_redirect! # ログイン後のリダイレクトを追跡
  # end


  before do
    Warden.test_mode!
    login_as(customer, scope: :customer)
  end

  after do
    Warden.test_reset!
  end



  describe "POST /create" do
    it "投稿詳細へ遷移すること" do
      post public_posts_path, params: { post: valid_attributes }
      expect(response).to redirect_to(post_path(Post.last))
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
      expect(response.body).to include("編集ページ") # 編集ページに含まれる内容を確認
    end
  end
end
context "投稿を更新する場合" do
  it "投稿詳細へ遷移すること" do
    post "/posts", params: { post: { content: "Test content" } }
    expect(response).to redirect_to(assigns(:post))
  end
end

context "投稿を削除する場合" do
  it "マイページへ遷移し、削除が反映されていること" do
    delete public_post_path(post)
    expect(response).to redirect_to public_customer_path(customer)
    follow_redirect!
    expect(response.body).not_to include(post.content)
  end
end
