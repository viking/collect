Sequel.migration do
  up do
    create_table(:roles) do
      primary_key :id
      foreign_key :user_id, :users
      foreign_key :project_id, :projects
      TrueClass :is_admin
    end
  end
end
