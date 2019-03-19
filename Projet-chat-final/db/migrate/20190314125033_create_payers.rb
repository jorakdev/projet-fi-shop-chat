class CreatePayers < ActiveRecord::Migration[5.2]
  def change
    create_table :payers do |t|
      t.integer :cart_id
      t.integer :current_user_id
      t.integer :total_to_pay
      t.string :customer_id
      t.string :custumer_email
      t.string :token

      t.timestamps
    end
  end
end
