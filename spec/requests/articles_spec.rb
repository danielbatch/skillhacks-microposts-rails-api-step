require 'rails_helper'

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /api/v1/articles" do
    subject { get(api_v1_articles_path, params: params) }
    
    before do
      create_list(:article, 2, :published)
      create_list(:article, 3, :draft)
    end
    
    context "パラメータ未指定の場合" do
      let(:params) { nil }
      it "ステータスがpublishedである記事が取得される" do
        subject
        res = JSON.parse(response.body)
        expect(res.length).to eq(2)
        expect(res[0]["status"]).to eq("published")
      end
    end
    
    context "draftパラメータを指定している場合" do
      let(:params) { { status: 'draft' } }
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
    
    context "適切なパラメータを送信した場合" do
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
    
    context "statusパラメータがない場合" do
      let(:params) { { article: { title: "Test title", body: "Test body", category_id: category.id } } }
      it "InvalidRequestErrorが発生する" do
        expect { subject }.to raise_error(InvalidRequestError)
      end
    end
    
    context "statusパラメータが不適切な場合" do
      let(:params) { { article: { title: "Test title", body: "Test body", status: "invalid_status", category_id: category.id } } }
      it "InvalidStatusErrorが発生する" do
        expect { subject }.to raise_error(InvalidStatusError)
      end
    end
  end

  describe "PUT /api/v1/articles/:id" do
    subject { put(api_v1_article_path(article.id), params: params) }
    let(:article) { create(:article, :published) }
    let(:category) { create(:category) }
    
    context "適切なパラメータを送信した場合" do
      let(:params) { { article: { title: "Updated title", body: "Updated body", status: "draft", category_id: category.id } } }
      it "記事が更新される" do
        expect { subject }.to change { article.reload.title }.to(params[:article][:title]) &
                              change { article.reload.body }.to(params[:article][:body]) &
                              change { article.reload.status }.to(params[:article][:status])
      end
    end
    
    context "statusパラメータが不適切な場合" do
      let(:params) { { article: { title: "Updated title", body: "Updated body", status: "invalid_status", category_id: category.id } } }
      it "InvalidStatusErrorが発生する" do
        expect { subject }.to raise_error(InvalidStatusError)
      end
    end
  end

  describe "DELETE /api/v1/articles/:id" do
    subject { delete(api_v1_article_path(article.id)) }
    let!(:article) { create(:article) }
    it "記事が削除される" do
      expect { subject }.to change { Article.count }.by(-1)
    end
  end
end