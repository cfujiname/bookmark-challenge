require 'database_helpers'
require 'comment'
require 'bookmark'

describe Comment do
  describe '.create' do
    it 'should create a new comment' do
      bookmark = Bookmark.create(url: 'http://www.pupalina.com', title: 'Pupalina')
      comment = Comment.create(text: 'test comment', bookmark_id: bookmark.id)

      persisted_data = persisted_data(table: 'comments', id: comment.id)
      expect(comment).to be_a Comment
      expect(comment.id).to eq persisted_data.first['id']
      expect(comment.text).to eq 'test comment'
      expect(comment.bookmark_id).to eq bookmark.id
    end
  end
  
  describe '.where' do
    it 'should query the relevant comments from database' do
      bookmark = Bookmark.create(url: 'http://www.pupalina.com', title: 'Pupalina')
      Comment.create(text: 'test comment 1', bookmark_id: bookmark.id)
      Comment.create(text: 'test comment 2', bookmark_id: bookmark.id)
      comments = Comment.where(bookmark_id: bookmark.id)
      comment = comments.first
      persisted_data = persisted_data(table: 'comments', id: comment.id)
      expect(comments.length).to eq 2
      expect(comment.id).to eq persisted_data.first['id']
      expect(comment.text).to eq 'test comment 1'
      expect(comment.bookmark_id).to eq bookmark.id
    end
  end
end