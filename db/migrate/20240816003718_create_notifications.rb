class CreateNotifications < ActiveRecord::Migration[6.1]
 def change
    create_table :notifications do |t|
      t.references :recipient, null: false, foreign_key: { to_table: :customers } # recipient_id カラムを作成し、users テーブルを参照
      t.references :sender, null: false, foreign_key: { to_table: :customers }    # sender_id カラムを作成し、users テーブルを参照
      t.references :chat, null: false, foreign_key: true                      # chat_id カラムを作成し、chats テーブルを参照
      t.boolean :read, null: false, default: false                            # read カラムを boolean 型で作成し、デフォルト値を false に設定

      t.timestamps
    end
 end
end
