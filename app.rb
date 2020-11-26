require 'sinatra/base'
require_relative './lib/bookmark'


class BookmarkManager < Sinatra::Base

  get '/' do
    erb:'index'
  end

  get '/bookmarks' do
    @bookmarks = Bookmark.all
    erb:'bookmarks'
  end

  get '/bookmarks/new' do
    erb:'bookmarks/new'
  end

  post '/bookmarks' do
    Bookmark.create(url: params[:url])
    redirect '/bookmarks'
  end


  run! if app_file == $0
end

