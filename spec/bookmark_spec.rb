require 'bookmark'
require 'database_helpers'
require 'tag'
require 'bookmark_tag'

describe Bookmark do

  let(:comment_class) { double(:comment_class) }
  let(:tag_class) { double(:tag_class) }

  describe '.all' do
    it 'should return a list of all bookmarks' do
      connection = PG.connect(dbname: 'bookmarks_test')

      bookmark = Bookmark.create(url: 'http://www.google.com', title: 'Google')
      Bookmark.create(url: 'http://www.destroyallsoftware.com', title: 'DAS')

      bookmarks = Bookmark.all

      expect(bookmarks.length).to eq 2
      expect(bookmarks.first).to be_a Bookmark
      expect(bookmarks.first.id).to eq bookmark.id
      expect(bookmarks.first.title).to eq 'Google'
      expect(bookmarks.first.url).to eq 'http://www.google.com'
    end
  end

  describe '.create' do
    it 'should create a new bookmark' do
      bookmark = Bookmark.create(url: 'http://www.gmail.com', title: 'Gmail')
      persisted_data = persisted_data(table: 'bookmark_manager', id: bookmark.id)
      expect(bookmark).to be_a Bookmark
      expect(bookmark.id).to eq persisted_data.first['id']
      expect(bookmark.url).to eq 'http://www.gmail.com'
      expect(bookmark.title).to eq 'Gmail'
    end

    it 'should not create a new bookmark if the url is invalid' do
      Bookmark.create(url: 'not a bookmark', title: 'fake bookmark')
      expect(Bookmark.all).to be_empty
    end  
  end

  describe '.delete' do
    it 'deletes the chosen bookmark' do
      bookmark = Bookmark.create(url: 'http://www.hello.com', title: 'hello')
      Bookmark.delete(id: bookmark.id)
      expect(Bookmark.all.length).to eq 0
    end
  end

  describe '.update' do
    it 'updates the chosen bookmark with new title and url' do
      bookmark = Bookmark.create(url: 'http://www.hola.com', title: 'hola')
      updated_bookmark = Bookmark.update(id: bookmark.id, url: 'http://www.adios.com', title: 'adios')
      expect(updated_bookmark).to be_a Bookmark
      expect(updated_bookmark.id).to eq bookmark.id
      expect(updated_bookmark.title).to eq 'adios'
      expect(updated_bookmark.url).to eq 'http://www.adios.com' 
    end
  end

  describe '.find' do
    it 'should return the object by resquested id' do
      bookmark = Bookmark.create(url: 'http://www.hola.com', title: 'hola')
      result = Bookmark.find(id: bookmark.id)
      expect(result).to be_a Bookmark
      expect(result.id).to eq bookmark.id
      expect(result.title).to eq 'hola'
      expect(result.url).to eq 'http://www.hola.com'
    end
  end

  describe '.where' do
    it 'should return bookmarks with a give tag id' do
      bookmark = Bookmark.create(url: "http://www.makersacademy.com", title: "Makers Academy")
      tag1 = Tag.create(content: 'test tag 1')
      tag2 = Tag.create(content: 'test tag 2')
      BookmarkTag.create(bookmark_id: bookmark.id, tag_id: tag1.id)
      BookmarkTag.create(bookmark_id: bookmark.id, tag_id: tag2.id)

      bookmarks = Bookmark.where(tag_id: tag1.id)
      result = bookmarks.first

      expect(bookmarks.length).to eq 1
      expect(result).to be_a Bookmark
      expect(result.id).to eq bookmark.id
      expect(result.title).to eq bookmark.title
      expect(result.url).to eq bookmark.url
    end
  end

  describe '#comments' do
    it 'should return a list of comments related to the bookmark' do
      bookmark = Bookmark.create(url: 'http://www.ina.com', title: 'Ina')
      DatabaseConnection.query("INSERT INTO comments (id, text, bookmark_id) VALUES(1, 'Test comment', #{bookmark.id});")
      comment = bookmark.comments.first
      expect(comment.text).to eq 'Test comment'
    end

    it 'should call .where on the Comment class' do
      bookmark = Bookmark.create(url: 'http://www.ina.com', title: 'Ina')
      expect(comment_class).to receive(:where).with(bookmark_id: bookmark.id)
      bookmark.comments(comment_class)
    end

    describe '#tags' do
      it 'should call .where on Tag class' do
        bookmark = Bookmark.create(url: 'http://www.pupa.com', title: 'Pupa')
        expect(tag_class).to receive(:where).with(bookmark_id: bookmark.id)
        bookmark.tags(tag_class)
      end
    end
  end
end
