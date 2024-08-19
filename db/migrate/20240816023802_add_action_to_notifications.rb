class AddActionToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :action, :string
  end
end
