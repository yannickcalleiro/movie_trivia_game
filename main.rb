require("sinatra")
require("sinatra/reloader") if development?
require("imdb")

enable :sessions

get "/search" do
	erb(:search)
end

# - ask them the question
# - user clicks a movie's button to select that movie

post "/search_results" do
	i = Imdb::Search.new(params[:search_term])
	@results =  moviefilter(i.movies[0..20])
	@movie_year_answer = @results[0]
	session[:correct_answer] = @movie_year_answer.id
	@results = @results.shuffle
	erb(:results)
end

def moviefilter(movies)
	movie_poster = []
	movies.each do | movie |
		if movie.poster != nil
			movie_poster.push(movie)
		end
	end
	return movie_poster[0..8]
end

post "/select_answer" do
	if params[:operation] == session[:correct_answer] 
		redirect to("/correct_answer")
	else
		redirect to("/try_again")
	end
end



get "/correct_answer" do
	"Congrats!!!"
end

get "/try_again" do
	"Try again"
end

# When the user submits the form, it should make a POST request to 
# another page that searches IMDB with that search term.
# Narrow down the search results to the first 9 movies.
# Show the posters of those 9 results.