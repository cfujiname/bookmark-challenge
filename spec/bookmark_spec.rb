require 'bookmark' 

describe Bookmark do
  subject(:bookmark) { Bookmark.new }
  
  describe '#all' do
    it 'prints a list of all bookmarks' do
      expect(subject.all).to eq 'List of all bookmarks'
    end
  end
end