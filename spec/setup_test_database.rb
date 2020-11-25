require 'pg'

def setup_test_database
  connection = PG.connect(dbname: 'bookmarks_test')
  connection.exec('TRUNCATE bookmark_manager_test;')
end