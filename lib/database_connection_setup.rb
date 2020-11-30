require './lib/database_connection'

if ENV['ENVIRONMENT'] == 'test'
  DatabaseConnection.setup('bookmarks_test')
else
  DatabaseConnection.setup('bookmarks')
end