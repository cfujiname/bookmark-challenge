require 'sinatra/base'
require_relative './lib/bookmark'
require_relative './lib/database_connection_setup'
require 'uri'
require 'sinatra/flash'


class BookmarkManager < Sinatra::Base

  enable :sessions, :method_override
  register Sinatra::Flash

  get '/' do
    'Bookmark Manager'
  end

  get '/bookmarks' do
    @bookmarks = Bookmark.all
    erb:'bookmarks/index'
  end

  get '/bookmarks/new' do
    erb:'bookmarks/new'
  end

  post '/bookmarks' do
    flash[:notice] = 'You must submit a valid URL' unless Bookmark.create(url: params[:url], title: params[:title])
    redirect '/bookmarks'
  end

  delete '/bookmarks/:id' do
    Bookmark.delete(id: params[:id])
    redirect '/bookmarks'
  end

  get '/bookmarks/:id/edit' do
    @bookmark = Bookmark.find(id: params[:id])
    erb:'/bookmarks/edit'
  end

  patch '/bookmarks/:id' do
    Bookmark.update(id: params[:id], url: params[:url], title: params[:title])
    redirect '/bookmarks'
  end


  run! if app_file == $0
end

