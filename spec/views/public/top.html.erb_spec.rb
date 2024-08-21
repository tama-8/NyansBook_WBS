require 'rails_helper'

RSpec.describe "public/homes/top", type: :view do
  before do
    # レイアウトを含めずにビューのみをレンダリング
    render template: "public/homes/top"
  end

  it "displays the welcome message" do
    expect(rendered).to have_css('h1', text: 'welcome')
  end
#テキストの部分一致を確認
 it "displays the SNS description" do
  expect(rendered).to have_css('p', text: /It is an SNS community site where pet owners connect.*by putting themselves in their cats’ shoes\./m)
end

  it "has a Guest sign in button" do
    expect(rendered).to have_link('Guest', href: customers_guest_sign_in_path)
  end

  it "has a Log in button" do
    expect(rendered).to have_link('Log in', href: new_customer_session_path)
  end

  it "has a Sign Up button" do
    expect(rendered).to have_link('Sign Up', href: new_customer_registration_path)
  end
end