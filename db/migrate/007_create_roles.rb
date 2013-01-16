Sequel.migration do
  up do
    create_table(:roles) do
      primary_key :id
      Integer :user_id
      Integer :project_id
      TrueClass :is_admin
      foreign_key [:user_id], :users, :name => 'roles_user_id_fkey'
      foreign_key [:project_id], :projects, :name => 'roles_project_id_fkey'
    end
  end
end
