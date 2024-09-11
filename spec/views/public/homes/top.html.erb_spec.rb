require "rails_helper"

RSpec.describe "public/homes/top", type: :view do
  context "ログインしていない場合" do
    before do
      # ログインしていない状態をシミュレート
      allow(view).to receive(:admin_signed_in?).and_return(false)
      allow(view).to receive(:customer_signed_in?).and_return(false)

      render template: "public/homes/top", layout: "layouts/application"
    end

    it "ログインしていない場合にゲスト向けのヘッダーリンクが表示されることを確認する" do
      expect(rendered).to have_link("Home", href: root_path)
      expect(rendered).to have_link("About", href: public_about_path)
      expect(rendered).to have_link("sign up", href: new_customer_registration_path)
      expect(rendered).to have_link("login", href: new_customer_session_path)
    end
  end


  # require "rails_helper"

  # RSpec.describe "public/homes/top", type: :view do
  let(:customer) { FactoryBot.create(:customer) }

  context "ログインしている場合" do
    before do
      allow(view).to receive(:admin_signed_in?).and_return(false)
      allow(view).to receive(:customer_signed_in?).and_return(true)
      allow(view).to receive(:current_customer).and_return(customer)

      assign(:unread_notifications_count, 5)

      render template: "public/homes/top", layout: "layouts/application"
    end

    it "ログインユーザー向けのヘッダーリンクを表示する" do
      # customerのIDを指定して正しいパスを生成
      expect(rendered).to have_link("MyHome", href: public_customer_path(customer))
      expect(rendered).to have_link("MyPage", href: public_mypage_path)
      expect(rendered).to have_link("NewPost", href: new_public_post_path)
      expect(rendered).to have_link("PostList", href: public_posts_path)
      expect(rendered).to have_link("logout", href: destroy_customer_session_path)
      expect(rendered).not_to have_link("sign up")
      expect(rendered).not_to have_link("login")
    end
  end
end
