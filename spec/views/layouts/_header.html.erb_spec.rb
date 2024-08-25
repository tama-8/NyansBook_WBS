require "rails_helper"

RSpec.describe "layouts/_header", type: :view do
  let(:customer) { FactoryBot.create(:customer) }

  context "ユーザーがログインしていない場合" do
    before do
      allow(view).to receive(:customer_signed_in?).and_return(false)
      allow(view).to receive(:admin_signed_in?).and_return(false)

      render partial: "layouts/header"
    end

    it "ゲスト向けのナビゲーションリンクが表示されることを確認する" do
      expect(rendered).to have_link("Home", href: root_path)
      expect(rendered).to have_link("About", href: public_about_path)
      expect(rendered).to have_link("sign up", href: new_customer_registration_path)
      expect(rendered).to have_link("login", href: new_customer_session_path)
      expect(rendered).not_to have_link("MyHome")
      expect(rendered).not_to have_link("MyPage")
      expect(rendered).not_to have_link("logout")
    end
  end

  context "顧客がログインしている場合" do
    before do
      allow(view).to receive(:customer_signed_in?).and_return(true)
      allow(view).to receive(:admin_signed_in?).and_return(false)
      allow(view).to receive(:current_customer).and_return(customer)

      # 未読通知のカウントを設定
      assign(:unread_notifications_count, 5)

      render partial: "layouts/header"
    end

    it "顧客向けのナビゲーションリンクが表示されることを確認する" do
      expect(rendered).to have_link("MyHome", href: public_customer_path(customer))
      expect(rendered).to have_link("MyPage", href: public_mypage_path)
      expect(rendered).to have_link("NewPost", href: new_public_post_path)
      expect(rendered).to have_link("PostList", href: public_posts_path)
      expect(rendered).to have_link("logout", href: destroy_customer_session_path)
      expect(rendered).not_to have_link("sign up")
      expect(rendered).not_to have_link("login")
    end
  end

  context "管理者がログインしている場合" do
    let(:admin) { FactoryBot.create(:admin) }

    before do
      allow(view).to receive(:admin_signed_in?).and_return(true)
      allow(view).to receive(:customer_signed_in?).and_return(false)
      allow(view).to receive(:current_admin).and_return(admin)

      render partial: "layouts/header"
    end

    it "管理者向けのナビゲーションリンクが表示されることを確認する" do
      expect(rendered).to have_link("ダッシュボード", href: admin_dashboard_path)
      expect(rendered).to have_link("Customer List", href: admin_root_path)
      expect(rendered).to have_link("Post List", href: admin_posts_path)
      expect(rendered).to have_link("Comment List", href: admin_post_comments_path)
      expect(rendered).to have_link("logout", href: destroy_admin_session_path)
      expect(rendered).not_to have_link("sign up")
      expect(rendered).not_to have_link("login")
      expect(rendered).not_to have_link("MyHome")
      expect(rendered).not_to have_link("MyPage")
    end
  end
end
