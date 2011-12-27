Sequel.migration do
  up do
    create_table(:authentications) do
      primary_key :id
      foreign_key :user_id, :users
      String :provider
      String :uid
    end
  end
end
