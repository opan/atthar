Hanami::Model.migration do
  change do
    create_table :products do
      primary_key :id
      foreign_key :product_category_id, :product_categories, on_delete: :set_null

      column :name, String, null: false
      column :sku, String, null: false, size: 20
      column :price, BigDecimal, null: false, default: 0, size: [15, 2]
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
      column :created_by_id, Bignum
      column :updated_by_id, Bignum
    end
  end
end
