require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'http'
require 'geocoder'
require 'dotenv/load'


def get_movies
  tmdb_api_key = ENV['TMDB_API_KEY']
  url = "https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=1"
  headers = { 'accept' => 'application/json', 'Authorization' => "Bearer #{tmdb_api_key}" }

  response = HTTP.get(url, headers: headers)
  response.code == 200 ? JSON.parse(response.body)['results'] : []
end

get '/' do
  erb :index
end

get '/movies' do
  @movies_nearby = get_movies
  erb :movies
end

def fetch_movie_info(movie_id)
  tmdb_api_key = ENV['TMDB_API_KEY']
  url = "https://api.themoviedb.org/3/movie/#{movie_id}?language=en-US"
  headers = { 'accept' => 'application/json', 'Authorization' => "Bearer #{tmdb_api_key}" }

  response = HTTP.get(url, headers: headers)
  if response.code == 200
    @movie = JSON.parse(response.body)
    erb :movie_info
  else
    erb :error_page
  end
end

get '/movie_info/:movie_id' do
  fetch_movie_info(params[:movie_id])
end
