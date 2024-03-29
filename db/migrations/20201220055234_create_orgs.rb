Hanami::Model.migration do
  change do
    create_table :orgs do
      primary_key :id, type: :Bignum

      column :name, String, null: false, unique: true
      column :display_name, String
      column :address, String
      column :phone_numbers, String
      column :is_root, TrueClass, null: false, default: false
      column :parent_id, Integer

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
      column :created_by_id, Integer
      column :updated_by_id, Integer

      index :name
    end
  end
end
