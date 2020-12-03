require_relative './database_connection'
require_relative './bookmark'

class Tag

  def self.create(content:)
    result = DatabaseConnection.query("SELECT * FROM tags WHERE content = '#{content}';").first
    if !result
      result = DatabaseConnection.query("INSERT INTO tags (content) VALUES('#{content}') RETURNING id, content;").first
    end
    Tag.new(id: result['id'], content: result['content'])
  end

  def self.where(bookmark_id:)
    result = DatabaseConnection.query("SELECT id, content FROM bookmarks_tags INNER JOIN tags ON tags.id = bookmarks_tags.tag_id WHERE bookmarks_tags.bookmark_id = '#{bookmark_id}';")
    result.map do |tag|
      Tag.new(id: tag['id'], content: tag['content'])
    end
  end

  def self.find(id:)
    result =  DatabaseConnection.query("SELECT * FROM tags WHERE id = #{id};")
    Tag.new(id: result[0]['id'], content: result[0]['content'])
  end

  attr_reader :id, :content

  def initialize(id:, content:)
    @id = id
    @content = content
  end

  def bookmarks(bookmark_class = Bookmark)
    bookmark_class.where(tag_id: id)
  end
end
