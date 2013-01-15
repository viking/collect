Sequel.migration do
  up do
    alter_table(:projects) do
      add_column(:status, String, :default => 'development')
    end
  end
end
