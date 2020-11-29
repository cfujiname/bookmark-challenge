require 'bookmark' 
require 'database_helpers'

describe Bookmark do
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
      persisted_data = persisted_data(id: bookmark.id)
      expect(bookmark).to be_a Bookmark
      expect(bookmark.id).to eq persisted_data.first['id']
      expect(bookmark.url).to eq 'http://www.gmail.com'
      expect(bookmark.title).to eq 'Gmail'
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
end
