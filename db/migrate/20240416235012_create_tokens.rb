class CreateTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :tokens do |t|
      t.string :token_type
      t.string :token
      t.references :user, type: :string, null: false, foreign_key: { primary_key: :user_id }

      t.timestamps
    end
  end
end
