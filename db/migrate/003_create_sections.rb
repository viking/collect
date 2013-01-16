Sequel.migration do
  up do
    create_table(:sections) do
      primary_key :id
      Integer :form_id
      String :name
      Integer :position
      foreign_key [:form_id], :forms, :name => 'sections_form_id_fkey'
    end
  end
end
