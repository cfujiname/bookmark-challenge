require 'pg'

class Bookmark

  def self.all
    connection = PG.connect(dbname: 'bookmarks')
    result = connection.exec('SELECT * FROM bookmark_manager')
    result.map { |bookmark| bookmark['url'] }
  end
end