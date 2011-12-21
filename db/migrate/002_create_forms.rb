Sequel.migration do
  up do
    create_table(:forms) do
      primary_key :id
      foreign_key :project_id, :projects
      String :name
      String :slug
      String :status
      TrueClass :repeatable
      TrueClass :primary
    end
  end
end
