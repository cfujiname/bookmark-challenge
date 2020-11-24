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
      expect(bookmarks).to include('google.com')
      expect(bookmarks).to include('gmail.com')
    end
  end
end