require 'rails_helper'

RSpec.describe Category, type: :model do
  context "nameが入力された時" do
    let(:category) { build(:category) }
    it "作成される" do
      expect(category).to be_valid
    end
  end

  context "nameが入力されなかった時" do
    let(:category) { build(:category, name: nil) }
    it "作成される" do
      expect(category).to be_invalid
    end
  end

  context "重複しているnameが入力された時" do
    before { create(:category, name: category_name) }

    let(:category) { build(:category, name: category_name )}
    let(:category_name) { "duplicate"} 
    it "エラーする" do
      expect(category).not_to be_valid
      expect(category.errors.messages[:name][0]).to eq "has already been taken"
    end
  end
end
