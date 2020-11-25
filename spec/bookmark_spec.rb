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
      bookmarks = Bookmark.all
      expect(bookmarks).to include('http://www.makersacademy.com')
      expect(bookmarks).to include('http://www.google.com')
      expect(bookmarks).to include('http://www.destroyallsoftware.com')
    end
  end
end