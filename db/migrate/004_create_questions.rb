Sequel.migration do
  up do
    create_table(:questions) do
      primary_key :id
      foreign_key :section_id, :sections
      String :name
      String :prompt
      String :type
      Integer :position
    end
  end
end
