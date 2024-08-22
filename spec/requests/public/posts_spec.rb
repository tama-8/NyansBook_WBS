#投稿機能に関するテスト
require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:customer) { FactoryBot.create(:customer) }
  let(:valid_attributes) { { content: "新しい投稿", image: fixture_file_upload('test_image.png', 'image/png') } }
  let(:invalid_attributes) { { content: "", image: nil } }

  before do
    sign_in customer
  end

  describe "POST /create" do
    it "投稿詳細へ遷移すること" do
      post public_posts_path, params: { post: valid_attributes }
      expect(response).to redirect_to(public_post_path(Post.last))
    end
  end

  describe "POST /create with invalid data" do
    it "バリデーションエラーメッセージが表示されること" do
      post public_posts_path, params: { post: invalid_attributes }
      document = Nokogiri::HTML(response.body)
      expect(document.css('div#error_explanation').text).to include("Contentを入力してください")
      expect(document.css('div#error_explanation').text).to include("Imageを選択してください")
    end
  end
end


  describe "投稿編集" do
    context "編集ページへの遷移" do
      it "編集ページが表示されること" do
        get edit_public_post_path(post)
        expect(response).to be_successful
      end
    end

    context "投稿を更新する場合" do
      it "投稿詳細へ遷移すること" do
        patch public_post_path(post), params: { post: { content: "更新された投稿" } }
        expect(response).to redirect_to public_post_path(post)
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
  end
end