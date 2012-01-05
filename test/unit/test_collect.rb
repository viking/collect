require 'helper'

class TestCollect < CollectUnitTest
  test "Database is a Sequel::Database" do
    assert_kind_of Sequel::Database, Collect::Database
  end
end
