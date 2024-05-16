require 'rails_helper'

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /api/v1/articles" do
    subject { get(api_v1_articles_path, params: params )}
    before do
      create_list(:article, 2, :published)
      create_list(:article, 3, :draft)
    end

    context "パラメータが未指定の場合" do
      let(:params) { nil }
      it "ステータスがpublishedである記事が取得される" do
        subject
        res = JSON.parse(response.body)

        expect(res.length).to eq(2)
        expect(res[0]["status"]).to eq("published")
      end
    end
    context "draftパラメータを指定している場合" do
      let(:params) { { status: "draft" } }
      it "ステータスがdraftである記事が取得される" do
        subject
        res = JSON.parse(response.body)

        expect(res.length).to eq(3)
        expect(res[0]["status"]).to eq("draft")
      end
    end
  end
  describe "POST /api/v1/articles" do
    subject { post(api_v1_articles_path, params: params) }
    let(:category) { create(:category) }

    context "statusパラメータがない場合" do
      let(:params) { { article: { title: "Test title", body: "Test body", category_id: category.id } } }
      it "InvalidRequestErrorが発生する" do
        expect { subject }.to raise_error(InvalidRequestError)
      end
    end

    context "statusパラメータが不正な場合" do
      let(:params) { { article: { title: "Test title", body: "Test body", status: "dummy", category_id: category.id } } }
      it "InvalidStatusErrorが発生する" do
        expect { subject }.to raise_error(InvalidStatusError)
      end
    end

    context "正常なパラメータを送信した場合" do
      let(:params) { { article: { title: "Test title", body: "Test body", status: "published", category_id: category.id } } }
      it "記事が作成される" do
        expect { subject }.to change { Article.count }.by(1)
        res = JSON.parse(response.body)

        expect(res["title"]).to eq("Test title")
        expect(res["body"]).to eq("Test body")
        expect(res["status"]).to eq("published")
        expect(res["category_id"]).to eq(category.id)
      end
    end
    
  end
  describe "PUT /api/v1/articles/:id" do
    subject { put(api_v1_article_path(article.id), params: params) }
  
    let(:article) { create(:article, status: "draft", category: category) }
    let(:category) { create(:category) }
  
    context "適切なパラメータを送信したとき" do
      let(:params) { { article: { title: "Updated title", body: "Updated body", status: "published" } } }
      it "更新される" do
        expect { subject }.to change { article.reload.title }.to(params[:article][:title]) &
                              change { article.body }.to(params[:article][:body]) &
                              change { article.status }.to(params[:article][:status])
      end
    end
  
    context "カテゴリーを変更したい場合" do
      let(:new_category) { create(:category, name: 'hogehoge') }
      let(:params) { { article: { status: "published", category_id: new_category.id } } }
      it "カテゴリーが更新される" do
        expect { subject }.to change { article.reload.category }.to(new_category)
      end
    end
  
    context "カテゴリーを変更しない場合" do
      let(:params) { { article: { title: "Updated title", body: "Updated body", status: "published" } } }
      it "カテゴリーは更新されない" do
        subject
        expect(article.reload.category).to eq(category)
      end
    end
  
    context "statusパラメータが不正な場合" do
      let(:params) { { article: { status: "dummy" } } }
      it "InvalidStatusErrorが発生する" do
        expect { subject }.to raise_error(InvalidStatusError)
      end
    end
  end

  describe "DELETE /api/v1/articles/:id" do
    subject { delete(api_v1_article_path(article.id)) }
    let!(:article) { create(:article)}
    it "記事が削除される" do
      expect { subject }.to change { Article.count}.by(-1)
    end
  end
end
