Sequel.migration do
  up do
    create_table(:authentications) do
      primary_key :id
      Integer :user_id
      String :provider
      String :uid
      foreign_key [:user_id], :users, :name => 'authentications_user_id_fkey'
    end
  end
end
