require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'net/http'
require 'uri'
require 'dotenv/load' # This loads the environment variables from .env

def get_movies_nearby()
  tmdb_api_key = ENV['TMDB_API_KEY']

  url = URI("https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=1")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new(url)
  request['accept'] = 'application/json'
  request['Authorization'] = "Bearer #{tmdb_api_key}"

  response = http.request(request)

  if response.code == '200'
    return JSON.parse(response.body)['results']
  else
    return []
  end
end

get '/' do

  erb :index
end

get '/movies' do
  @movies_nearby = get_movies_nearby()

  erb :movies
end
