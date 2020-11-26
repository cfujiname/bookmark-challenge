require 'bookmark' 

describe Bookmark do
  subject(:bookmark) { Bookmark.new }
  let(:bookmark_list) do
    [
      'google.com',
      'gmail.com'
    ]
  end
  
  describe '.all' do
    it 'should return a list of all bookmarks' do
      connection = PG.connect(dbname: 'bookmarks_test')
      connection.exec("INSERT INTO bookmark_manager_test (url) VALUES ('http://www.makersacademy.com');")
      connection.exec("INSERT INTO bookmark_manager_test (url) VALUES ('http://www.destroyallsoftware.com');")
      connection.exec("INSERT INTO bookmark_manager_test (url) VALUES ('http://www.google.com');")

      bookmarks = Bookmark.all
      expect(bookmarks).to include('http://www.makersacademy.com')
      expect(bookmarks).to include('http://www.google.com')
      expect(bookmarks).to include('http://www.destroyallsoftware.com')
    end
  end

  describe '.create' do
    it 'should create a new bookmark' do
      Bookmark.create(url: 'http://www.hello.com')
      expect(Bookmark.all).to include 'http://www.hello.com'
    end
  end
end