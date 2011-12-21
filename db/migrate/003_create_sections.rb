Sequel.migration do
  up do
    create_table(:sections) do
      primary_key :id
      foreign_key :form_id, :forms
      String :name
      Integer :position
    end
  end
end
