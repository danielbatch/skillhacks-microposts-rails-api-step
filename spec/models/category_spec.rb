require 'rails_helper'

RSpec.describe Category, type: :model do
    context "nameが入力されたとき" do
      let(:category) { build(:category) }
  
      it "エラーしない" do
        expect(category).to be_valid
      end
    end
  
    context "nameが入力されなかったとき" do
      let(:category) { build(:category, name: nil) }
  
      it "エラーする" do
        aggregate_failures do
          expect(category).not_to be_valid
          expect(category.errors.messages[:name][0]).to eq "can't be blank"
        end
      end
    end
  
    context "重複しているnameが入力されたとき" do
      before { create(:category, name: category_name) }
  
      let(:category) { build(:category, name: category_name) }
      let(:category_name) { "プログラミング" }
  
      it "エラーする" do
        aggregate_failures do
          expect(category).not_to be_valid
          expect(category.errors.messages[:name][0]).to eq "has already been taken"
        end
      end
    end
  end
  
