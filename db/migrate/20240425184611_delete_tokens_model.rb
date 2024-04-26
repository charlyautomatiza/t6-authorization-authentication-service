class DeleteTokensModel < ActiveRecord::Migration[7.1]
  def change
    drop_table :tokens
  end
end
