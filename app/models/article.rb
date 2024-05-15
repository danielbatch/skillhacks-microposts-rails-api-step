class Article < ApplicationRecord
    TITLE_MAX_LENGTH = 20
    BODY_MAX_LENGTH = 150

    belongs_to :category
    enum status: { draft: "draft", published: "published" }
    validates :title, presence: true, length: { maximum: TITLE_MAX_LENGTH }
    validates :body, presence: true, length: { maximum: BODY_MAX_LENGTH }
end
