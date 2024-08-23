class Batch::DataReset
  def self.data_reset
    # 投稿を全て削除
    # Post.delete_all # これは対象モデルのみを削除する
    Post.destroy_all # モデルファイルを参照して関連するものも削除する
    p "投稿を全て削除しました"
  end
end
