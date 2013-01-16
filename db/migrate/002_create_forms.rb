Sequel.migration do
  up do
    create_table(:forms) do
      primary_key :id
      Integer :project_id
      String :name
      String :slug
      String :status
      TrueClass :repeatable
      TrueClass :primary
      foreign_key [:project_id], :projects, :name => 'forms_project_id_fkey'
    end
  end
end
