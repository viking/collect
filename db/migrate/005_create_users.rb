Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id
      String :username
      String :fullname
      String :email
    end
  end
end
