Hanami::Model.migration do
  change do
    create_table :pos do
      primary_key :id
      foreign_key :org_id, :orgs, on_delete: :set_null

      column :session_id, String, null: false
      column :cashier_id, Integer, null: false
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
      column :created_by_id, Integer
      column :updated_by_id, Integer
    end
  end
end