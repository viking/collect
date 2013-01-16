Sequel.migration do
  up do
    create_table(:questions) do
      primary_key :id
      Integer :section_id
      String :name
      String :prompt
      String :type
      Integer :position
      foreign_key [:section_id], :sections, :name => 'questions_section_id_fkey'
    end
  end
end
