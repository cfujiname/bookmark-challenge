require 'pg'

class Bookmark

  def self.all
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'bookmarks_test')
    else
      connection = PG.connect(dbname: 'bookmarks')
    end
    result = connection.exec('SELECT * FROM bookmark_manager')
    result.map { |bookmark| bookmark['url'] }
  end

  def self.create(url:)
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'bookmarks_test')
    else
      connection = PG.connect(dbname: 'bookmarks')
    end
    connection.exec("INSERT INTO bookmark_manager (url) VALUES ('#{url}')")
  end
end
