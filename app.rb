require 'sinatra/base'
require_relative './lib/bookmark'


class BookmarkManager < Sinatra::Base

  get '/' do
    erb(:index)
  end

  get '/bookmarks' do
    @bookmarks = Bookmark.all
    erb(:bookmarks)
  end

  get '/bookmarks/new' do
    'new bookmark'
  end


  run! if app_file == $0
end

