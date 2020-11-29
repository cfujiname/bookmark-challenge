require 'pg'

class Bookmark

  def self.all
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'bookmarks_test')
    else
      connection = PG.connect(dbname: 'bookmarks')
    end
    result = connection.exec('SELECT * FROM bookmark_manager')
    result.map do |bookmark|
      Bookmark.new(
        id: bookmark['id'],
        title: bookmark['title'],
        url: bookmark['url']
      )
    end
  end

  def self.create(url:, title:)
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'bookmarks_test')
    else
      connection = PG.connect(dbname: 'bookmarks')
    end
    result = connection.exec(
      "INSERT INTO bookmark_manager (url, title)
      VALUES('#{url}', '#{title}')
      RETURNING id, url, title"
    )
    Bookmark.new(
      id: result[0]['id'],
      title: result[0]['title'],
      url: result[0]['url']
    )
  end

  def self.delete(id:)
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'bookmarks_test')
    else
      connection = PG.connect(dbname: 'bookmarks')
    end
    connection.exec("DELETE FROM bookmark_manager WHERE id = #{id}")
  end

  def self.update(id:, title:, url:)
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'bookmarks_test')
    else
      connection = PG.connect(dbname: 'bookmarks')
    end
    result = connection.exec("UPDATE bookmark_manager SET url = '#{url}', title = '#{title}' WHERE id = #{id} RETURNING id, url, title;")
    Bookmark.new(id: result[0]['id'], title: result[0]['title'], url: result[0]['url'])
  end

  def self.find(id:)
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'bookmarks_test')
    else
      connection = PG.connect(dbname: 'bookmarks')
    end
    result = connection.exec("SELECT * FROM bookmark_manager WHERE id = #{id};")
    Bookmark.new(id: result[0]['id'], title: result[0]['title'], url: result[0]['url'])
  end


  attr_reader :id, :title, :url

  def initialize(id:, title:, url:)
    @id = id
    @title = title
    @url = url
  end
  
end
