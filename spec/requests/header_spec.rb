#ヘッダーリンク先テスト
require 'rails_helper'
require 'devise'

RSpec.describe "Header Links", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:customer) { FactoryBot.create(:customer) }

  describe "ヘッダーリンクのテスト" do
    before do
      sign_in customer
    end

    it "ログアウトリンクを押下する" do
      delete destroy_customer_session_path
      expect(response).to redirect_to public_about_path
    end

    it "投稿一覧へのリンクが正しく動作すること" do
      get public_posts_path
      expect(response).to be_successful
    end

    it "マイページへのリンクが正しく動作すること" do
      get public_customer_path(customer)
      expect(response).to be_successful
    end

    it "新規投稿へのリンクが正しく動作すること" do
      get new_public_post_path
      expect(response).to be_successful
    end

    it "アバウトへのリンクが正しく動作すること" do
      get public_about_path
      expect(response).to be_successful
    end

    it "My Homeへのリンクが正しく動作すること" do
      get public_customer_path(customer)
      expect(response).to be_successful
    end

    it "いいね一覧へのリンクが正しく動作すること" do
      get favorites_public_posts_path
      expect(response).to be_successful
    end

    it "通知ページへのリンクが正しく動作すること" do
      get public_notifications_path
      expect(response).to be_successful
    end
  end
end