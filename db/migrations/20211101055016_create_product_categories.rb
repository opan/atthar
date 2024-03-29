Hanami::Model.migration do
  change do
    create_table :product_categories do
      primary_key :id

      column :name, String, null: false
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
      column :created_by_id, Integer
      column :updated_by_id, Integer
    end
  end
end
