require_relative 'database_connection'

class Bookmark

  def self.all
    result = DatabaseConnection.query("SELECT * FROM bookmark_manager")
    result.map do |bookmark|
      Bookmark.new(
        id: bookmark['id'],
        title: bookmark['title'],
        url: bookmark['url']
      )
    end
  end

  def self.create(url:, title:)
    result = DatabaseConnection.query(
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
    DatabaseConnection.query("DELETE FROM bookmark_manager WHERE id = #{id}")
  end

  def self.update(id:, title:, url:)
    result = DatabaseConnection.query("UPDATE bookmark_manager SET url = '#{url}', title = '#{title}' WHERE id = #{id} RETURNING id, url, title;")
    Bookmark.new(id: result[0]['id'], title: result[0]['title'], url: result[0]['url'])
  end

  def self.find(id:)
    result = DatabaseConnection.query("SELECT * FROM bookmark_manager WHERE id = #{id};")
    Bookmark.new(id: result[0]['id'], title: result[0]['title'], url: result[0]['url'])
  end


  attr_reader :id, :title, :url

  def initialize(id:, title:, url:)
    @id = id
    @title = title
    @url = url
  end
  
end
