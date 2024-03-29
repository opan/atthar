# frozen_string_literal: true

Hanami::Model.migration do
  change do
    create_table :pos_trxes do
      primary_key :id
      foreign_key :point_of_sale_id, :point_of_sales, on_delete: :cascade

      column :trx_id, String, null: false
      column :state, Integer, null: false
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
      column :created_by_id, Integer
      column :updated_by_id, Integer

      index %i[trx_id point_of_sale_id], unique: true
    end
  end
end
