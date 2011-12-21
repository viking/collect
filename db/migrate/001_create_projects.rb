Sequel.migration do
  up do
    create_table(:projects) do
      primary_key :id
      String :name
      String :database_adapter
      String :database_options
    end
  end
end
