require "rails_helper"

RSpec.describe "admin/dashboard/index", type: :view do
  context "管理者がログインしている場合" do
    before do
      admin = FactoryBot.create(:admin)

      # ダミーデータの設定
      recent_customers = FactoryBot.create_list(:customer, 5)
      recent_posts = FactoryBot.create_list(:post, 5)
      recent_comments = FactoryBot.create_list(:post_comment, 5)
      assign(:recent_customers, recent_customers)
      assign(:recent_posts, recent_posts)
      assign(:recent_comments, recent_comments)

      # 管理者のログイン状態をシミュレート
      allow(view).to receive(:admin_signed_in?).and_return(true)
      allow(view).to receive(:current_admin).and_return(admin)

      # 管理者ログイン後の遷移先のページをレンダリング
      render template: "admin/dashboard/index", layout: "layouts/application"
    end

    it "管理者向けのナビゲーションリンクが表示されることを確認する" do
      expect(rendered).to have_link("ダッシュボード", href: admin_dashboard_path)
      expect(rendered).to have_link("Customer List", href: admin_root_path)
      expect(rendered).to have_link("Post List", href: admin_posts_path)
      expect(rendered).to have_link("Comment List", href: admin_post_comments_path)
      expect(rendered).to have_link("logout", href: destroy_admin_session_path)
    end
  end

  context "管理者がログインしていない場合" do
    before do
      # 管理者のログイン状態がfalseであることをシミュレート
      allow(view).to receive(:admin_signed_in?).and_return(false)
      allow(view).to receive(:customer_signed_in?).and_return(false)
      # Devise関連のリソースを設定
      view.define_singleton_method(:resource) { Customer.new }
      view.define_singleton_method(:resource_name) { :customer }
      view.define_singleton_method(:devise_mapping) { Devise.mappings[:customer] }
      # ログインページをレンダリング
      render template: "devise/sessions/new", layout: "layouts/application"
    end

    it "ログインページにゲスト向けのナビゲーションリンクが表示されることを確認する" do
      expect(rendered).to have_link("Home", href: root_path)
      expect(rendered).to have_link("About", href: public_about_path)
      expect(rendered).to have_link("sign up", href: new_customer_registration_path)
      expect(rendered).to have_link("login", href: new_customer_session_path)
      expect(rendered).not_to have_link("MyHome")
      expect(rendered).not_to have_link("MyPage")
      expect(rendered).not_to have_link("logout")
    end
  end
end
