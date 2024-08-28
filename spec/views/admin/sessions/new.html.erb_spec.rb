require "rails_helper"

RSpec.describe "admin/sessions/new", type: :view do
  before do
    # Devise関連のリソースを設定
    view.define_singleton_method(:resource_name) { :admin }
    view.define_singleton_method(:resource) { Admin.new }
    view.define_singleton_method(:devise_mapping) { Devise.mappings[:admin] }

    # `admin_signed_in?`をモック
    allow(view).to receive(:admin_signed_in?).and_return(false)
    allow(view).to receive(:customer_signed_in?).and_return(false)

    # ログインページをレンダリング
    render template: "admin/sessions/new", layout: "layouts/application"
  end

  it "管理者ログインページが正しく表示されることを確認する" do
    expect(rendered).to have_selector("form[action='#{admin_session_path}']")
    expect(rendered).to have_field("admin[email]")
    expect(rendered).to have_field("admin[password]")
    expect(rendered).to have_button("ログイン")
  end
end
