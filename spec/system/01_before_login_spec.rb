require 'rails_helper'

describe '[STEP1] ユーザログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'URLが正しい', spec_category: "ルーティング・URL設定の理解(ログイン状況に合わせた応用)" do
        expect(current_path).to eq '/'
      end
       it 'Guest Log inリンクが表示される: グレーのボタンの表示が「Guest」である', spec_category: "ルーティング・URL設定の理解(ログイン状況に合わせた応用)" do
          log_in_link = find_link('Guest')
      end
      it 'Guest Log inリンクの内容が正しい', spec_category: "ルーティング・URL設定の理解(ログイン状況に合わせた応用)" do
        expect(page).to have_link('Guest', href: customers_guest_sign_in_path)
      end
       it 'Log inリンクが表示される: 青色のボタンの表示が「Log in」である', spec_category: "ルーティング・URL設定の理解(ログイン状況に合わせた応用)" do
          log_in_link = find_link('Log in')
      end
       it 'Log inリンクの内容が正しい', spec_category: "ルーティング・URL設定の理解(ログイン状況に合わせた応用)" do
        expect(page).to have_link('Log in',href: new_customer_session_path)
      end
      it 'Sign upリンクが表示される: 緑色のボタンの表示が「Sign up」である', spec_category: "ルーティング・URL設定の理解(ログイン状況に合わせた応用)" do
        log_in_link = find_link('Sign Up')
      end
      it 'Sign upリンクの内容が正しい', spec_category: "ルーティング・URL設定の理解(ログイン状況に合わせた応用)" do
        expect(page).to have_link('Sign Up',href: new_customer_registration_path)
      end
    end
  end

  describe 'アバウト画面のテスト' do
    before do
      visit '/public/about'
    end

    context '表示内容の確認' do
      it 'URLが正しい', spec_category: "ルーティング・URL設定の理解(ログイン状況に合わせた応用)" do
        expect(current_path).to eq '/public/about'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit root_path
    end

  context '表示内容の確認' do
    it 'Homeリンクが表示される: 左上から1番目のリンクが「Home」である' do
      home_link = find_all('li')[0].text
      expect(home_link).to match(/Home/)
    end

    it 'Aboutリンクが表示される: 左上から2番目のリンクが「About」である' do
      about_link = find_all('li')[1].text
      expect(about_link).to match(/About/)
    end

    it 'sign upリンクが表示される: 左上から3番目のリンクが「sign up」である' do
      signup_link = find_all('li')[2].text
      expect(signup_link).to match(/sign up/)
    end

    it 'loginリンクが表示される: 左上から4番目のリンクが「login」である' do
      login_link = find_all('li')[3].text
      expect(login_link).to match(/login/)
    end
  end
end

    context 'リンクの内容を確認' do
      subject { current_path }
      
      it 'ロゴを押すと、トップ画面に遷移する' do
        visit root_path # 必要に応じて、他のパスを指定
        save_and_open_page  # この行でページの内容を確認できます
        find('a img[alt="にゃんずbookロゴ"]').click
        expect(page).to have_current_path(root_path)
      end
        it 'ログインしていない時、Homeリンクが表示される' do
        visit root_path
        expect(page).to have_link('Home', href: root_path)
      end
      
      it 'ログインしていない時、Aboutリンクが表示される' do
        visit root_path
        expect(page).to have_link('About', href: public_about_path)
      end
      
      it 'ログインしていない時、sign upリンクが表示される' do
        visit root_path
        expect(page).to have_link('sign up', href: new_customer_registration_path)
      end
      
      it 'ログインしていない時、loginリンクが表示される' do
        visit root_path
        expect(page).to have_link('login', href: new_customer_session_path)
      end
    end
  end

  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_customer_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい', spec_category: "deviseの基本的な導入・認証設定" do
        expect(current_path).to eq '/customers/sign_up'
      end
      it '「Sign up」と表示される', spec_category: "deviseの基本的な導入・認証設定" do
        expect(page).to have_content 'Sign up'
      end
      it 'nameフォームが表示される', spec_category: "deviseの基本的な導入・認証設定" do
      expect(page).to have_field 'customer[name]'
    end
      it 'emailフォームが表示される', spec_category: "deviseの基本的な導入・認証設定" do
        expect(page).to have_field 'customer[email]'
      end
      it 'passwordフォームが表示される', spec_category: "deviseの基本的な導入・認証設定" do
        expect(page).to have_field 'customer[password]'
      end
   it 'password_confirmationフォームが表示される', spec_category: "deviseの基本的な導入・認証設定" do
  expect(page).to have_selector("input[name='customer[password_confirmation]']")
end
      it 'Sign upボタンが表示される', spec_category: "deviseの基本的な導入・認証設定" do
        expect(page).to have_button 'Sign up'
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'customer[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'customer[email]', with: Faker::Internet.email
        fill_in 'customer[password]', with: 'password'
        fill_in 'customer[password_confirmation]', with: 'password'
      end

      it '正しく新規登録される', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        expect { click_button 'Sign up' }.to change(Customer, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録できたユーザの詳細画面になっている', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        click_button 'Sign up'
        expect(current_path).to eq '/public/customers/' + Customer.last.id.to_s
      end
    end
  end
  
describe 'ゲストログイン' do
  include Devise::Test::IntegrationHelpers
before do
      visit root_path
      click_on 'Guest'
    end
  it 'ゲストユーザーがログインできること' do
    expect(current_path).to eq '/public/customers/' + Customer.find_by(email: "guest@example.com").id.to_s
  end
  it "ゲストユーザーがログイン時にフラッシュメッセージが出ること" do
    expect(page).to have_content 'ゲストユーザーとしてログインしました。'
    
  end
end
  describe 'ユーザログイン' do
    let(:customer) { create(:customer) }

    before do
      visit new_customer_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい', spec_category: "deviseの基本的な導入・認証設定" do
        expect(current_path).to eq '/customers/sign_in'
      end
      it '「Log in」と表示される', spec_category: "deviseの基本的な導入・認証設定" do
        expect(page).to have_content 'Log in'
      end
      it 'emailフォームが表示される', spec_category: "deviseの基本的な導入・認証設定" do
        expect(page).to have_field 'customer[email]'
      end
      it 'passwordフォームが表示される', spec_category: "deviseの基本的な導入・認証設定" do
        expect(page).to have_field 'customer[password]'
      end
      it 'Log inボタンが表示される', spec_category: "deviseの基本的な導入・認証設定" do
        expect(page).to have_button 'Log in'
      end
      it 'nameフォームは表示されない', spec_category: "deviseの基本的な導入・認証設定" do
        expect(page).not_to have_field 'customer[name]'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'customer[email]', with: customer.email
        fill_in 'customer[password]', with: customer.password
        click_button 'Log in'
      end

      it 'ログイン後のリダイレクト先が、ログインしたユーザの詳細画面になっている', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        expect(current_path).to eq '/public/customers/' + customer.id.to_s
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'customer[email]', with: ''
        fill_in 'customer[password]', with: ''
        click_button 'Log in'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        expect(current_path).to eq '/customers/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    let(:customer) { create(:customer) }

    before do
      visit new_customer_session_path
      fill_in 'customer[email]', with: customer.email
      fill_in 'customer[password]', with: customer.password
      click_button 'Log in'
    end

        context 'ヘッダーの表示を確認' do
      it 'MyHomeリンクが表示される: 左上から1番目のリンクが「MyHome」である', spec_category: "ログイン状況に合わせた画面表示や機能制限のロジック設定" do
        my_home_link = find_all('li')[0].text
        expect(my_home_link).to match(/MyHome/)
      end
    
      it 'MyPageリンクが表示される: 左上から2番目のリンクが「MyPage」である', spec_category: "ログイン状況に合わせた画面表示や機能制限のロジック設定" do
        my_page_link = find_all('li')[1].text
        expect(my_page_link).to match(/MyPage/)
      end
    
      it 'NewPostリンクが表示される: 左上から3番目のリンクが「NewPost」である', spec_category: "ログイン状況に合わせた画面表示や機能制限のロジック設定" do
        new_post_link = find_all('li')[2].text
        expect(new_post_link).to match(/NewPost/)
      end
    
      it 'PostListリンクが表示される: 左上から4番目のリンクが「PostList」である', spec_category: "ログイン状況に合わせた画面表示や機能制限のロジック設定" do
        post_list_link = find_all('li')[3].text
        expect(post_list_link).to match(/PostList/)
      end
    
      it 'いいねListリンクが表示される: 左上から5番目のリンクが「いいねList」である', spec_category: "ログイン状況に合わせた画面表示や機能制限のロジック設定" do
        favorites_link = find_all('li')[4].text
        expect(favorites_link).to match(/いいねList/)
      end
    
      it '通知リンクが表示される: 左上から6番目のリンクが「通知」である', spec_category: "ログイン状況に合わせた画面表示や機能制限のロジック設定" do
        notifications_link = find_all('li')[5].text
        expect(notifications_link).to match(/通知/)
      end
    
      it 'logoutリンクが表示される: 左上から7番目のリンクが「logout」である', spec_category: "ログイン状況に合わせた画面表示や機能制限のロジック設定" do
        logout_link = find_all('li')[6].text
        expect(logout_link).to match(/logout/)
      end
    
      it 'ロゴを押すと、トップ画面に遷移する', spec_category: "ルーティング・URL設定の理解(ログイン状況に合わせた応用)" do
        find('img[alt="にゃんずbookロゴ"]').click
        expect(current_path).to eq root_path
      end
    end
  end

  describe 'ユーザログアウトのテスト' do
    let(:customer) { create(:customer) }

    before do
      visit new_customer_session_path
      fill_in 'customer[email]', with: customer.email
      fill_in 'customer[password]', with: customer.password
      click_button 'Log in'
      logout_link = find_all('li')[4].text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
    end

    context 'ログアウト機能のテスト' do
      it '正しくログアウトできている: ログアウト後のリダイレクト先においてAbout画面へのリンクが存在する', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        expect(page).to have_link 'About', href: '/public/home/about'
      end
      it 'ログアウト後のリダイレクト先が、トップになっている', spec_category: "CRUD機能に対するコントローラの処理と流れ(ログイン状況を意識した応用)" do
        expect(current_path).to eq '/'
      end
    end
  end

