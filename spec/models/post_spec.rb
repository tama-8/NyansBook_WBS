require "rails_helper"

RSpec.describe "Postモデルのテスト", type: :model do
  describe "バリデーションのテスト" do
    subject { post.valid? }

    let(:customer) { create(:customer) }
    let!(:post) { build(:post, customer_id: customer.id) }

    context "imageアタッチメント" do
      it "画像が添付されていること", spec_category: "バリデーションとメッセージ表示" do
        post.image.attach(nil)
        expect(post.valid?).to eq false
        expect(post.errors[:image]).to include("を選択してください")
      end
    end

    context "contentカラム" do
      it "空欄でないこと", spec_category: "バリデーションとメッセージ表示" do
        post.content = ""
        is_expected.to eq false
      end
      it "200文字以下であること: 200文字は〇", spec_category: "バリデーションとメッセージ表示" do
        post.content = Faker::Lorem.characters(number: 200)
        is_expected.to eq true
      end
      it "200文字以下であること: 201文字は×", spec_category: "バリデーションとメッセージ表示" do
        post.content = Faker::Lorem.characters(number: 201)
        is_expected.to eq false
      end
    end
  end

  describe "アソシエーションのテスト" do
    context "Cutomerモデルとの関係" do
      it "N:1となっている", spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(Post.reflect_on_association(:customer).macro).to eq :belongs_to
      end
    end
  end
end
