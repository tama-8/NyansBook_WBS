require 'rails_helper'

RSpec.describe "AdminSessions", type: :request do
  describe "GET /admin" do
    it "管理者ログインページが表示されることを確認する" do
      get new_admin_session_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("ログイン")  # ログインページに含まれるテキストを確認
    end
  end

  describe "POST /admin" do
    context "無効な管理者の認証情報を使用した場合" do
      it "ログインに失敗し、エラーメッセージが表示される" do
        post admin_session_path, params: { admin: { email: "wrong@example.com", password: "wrongpassword" } }
        expect(response.body).to include("メールアドレスまたはパスワードが無効です")
      end
    end
  end
end