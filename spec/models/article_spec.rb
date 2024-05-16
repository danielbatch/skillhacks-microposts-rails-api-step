require 'rails_helper'

RSpec.describe Article, type: :model do
  context "全てのデータが正常な時" do
    let(:article) { build(:article) }
    it "作成できる" do
      expect(article.valid?).to eq(true)
    end
  end
  context "titleが入力されなかった時" do
    let(:article) { build(:article, title: nil) }

    it "エラーする" do
      expect(article.valid?).to eq(false)
    end
  end
  context "bodyが入力されなかった時" do
    let(:article) { build(:article, body: nil) }

    it "エラーする" do
      expect(article.valid?).to eq(false)
    end
  end
  context "statusが入力されなかった時" do
    let(:article) { build(:article, status: nil) }

    it "エラーする" do
      expect(article.valid?).to eq(false)
    end
  end

  # 不正な値を防止する
  context "タイトルの長さが不正なとき" do
    let(:article) { build(:article, title: "a" * 50) }
    it "エラーする" do
      expect(article.valid?).to eq(false)
    end
  end
  context "bodyの長さが不正なとき" do
    let(:article) { build(:article, body: "a" * 200) }
    it "エラーする" do
      expect(article.valid?).to eq(false)
    end
  end
  context "status が異常なとき" do
    it "エラーする" do
      expect{ build(:article, status: 'dummy')}.to raise_error(ArgumentError, "'dummy' is not a valid status")
    end
  end
end
