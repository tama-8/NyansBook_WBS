# ユーザー認証に関するテスト
require "rails_helper"

RSpec.describe "Customer Authentication", type: :request do
    include Rails.application.routes.url_helpers  # routesを明示的にインクルード
    let(:customer) { create(:customer) } # customerの定義

    describe "ログイン機能" do
    context "正しい情報を使用してログインする場合" do
        it "My Homeが正しく表示されること" do
          customer = create(:customer)
          post customer_session_path, params: { customer: { email: customer.email, password: customer.password } }
          expect(response).to redirect_to(public_customer_path(customer))
        end
      end
    context "誤った情報を使用してログインする場合" do
      it "再度ログイン画面が表示されること" do
        post customer_session_path, params: { customer: { email: customer.email, password: "wrongpassword" } }
        expect(response.body).to include("メールアドレスまたはパスワードが無効です")
      end
    end
  end

    describe "ユーザー登録機能" do
    context "必要事項を入力して新規登録する場合" do
      it "マイページが表示されること" do
        post customer_registration_path, params: { customer: { name: "Test User", email: "new@example.com", password: "password", password_confirmation: "password" } }

        customer = Customer.last
        expect(customer).not_to be_nil  # Customerが正しく作成されていることを確認
        expect(response).to redirect_to public_customer_path(customer)
      end
    end
  end

    context "必要事項が不足している場合" do
      it "バリデーションエラーメッセージが表示されること" do
        post customer_registration_path, params: { customer: { email: "", password: "", password_confirmation: "" } }
        expect(response.body).to include("Emailを入力してください")
        expect(response.body).to include("Passwordを入力してください")
        expect(response.body).to include("Nameを入力してください")
      end
    end
  end
