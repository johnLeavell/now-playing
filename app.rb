require "sinatra"
require "sinatra/reloader"
require "httparty"

get("/") do
  erb :index
end

def get_movies_nearby()
  tmdb_api_key = ENV.fetch('TMDB_API_KEY')

  url = "https://api.themoviedb.org/3/movie/now_playing"
  params = {
    api_key: tmdb_api_key,
    language: 'en-US',
    page: 1,
    region: 'US', 
  }

  response = HTTParty.get(url, query: params)


  if response.code == 200
    return JSON.parse(response.body)['results']
  else
    return []
  end
end

get("/movies") do
  @movies_nearby = get_movies_nearby()
  
  erb :movies
end
