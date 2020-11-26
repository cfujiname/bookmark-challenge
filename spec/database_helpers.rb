require 'pg'

def persisted_data(id:)
  connection = PG.connect(dbname: 'bookmarks_test')
  connection.query("SELECT * FROM bookmark_manager WHERE id = #{id};")
end