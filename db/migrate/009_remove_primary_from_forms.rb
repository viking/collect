Sequel.migration do
  up do
    alter_table(:forms) do
      drop_column(:primary)
    end
  end
end
