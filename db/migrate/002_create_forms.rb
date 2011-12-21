Sequel.migration do
  up do
    create_table(:forms) do
      primary_key :id
      foreign_key :project_id, :projects
      String :name
      String :slug
      TrueClass :repeatable
      String :status
    end
  end
end
