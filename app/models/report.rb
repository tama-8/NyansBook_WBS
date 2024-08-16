class Report < ApplicationRecord
  belongs_to :reporter, class_name: "Customer", foreign_key: "reporter_id"
  belongs_to :reported, class_name: "Customer", foreign_key: "reported_id"
  # 通報対象のコンテンツを示す多様性（Polymorphic）関連付け
  belongs_to :content, polymorphic: true
  
  # 通報理由の列挙型（Enum）
  enum reason: {
    malicious_expression: 0,      # 悪意のある表現
    inappropriate_content: 1,     # 不適切なコンテンツ
    misinformation: 2,            # 誤った情報
    commercial_purposes: 3,       # 商業目的
    spam: 4,                      # スパム
    other: 5                      # その他
  }
end
