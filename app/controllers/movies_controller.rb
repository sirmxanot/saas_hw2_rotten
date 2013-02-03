class MoviesController < ApplicationController
  helper_method :sort_column, :sort_direction, :checked_ratings

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Hash[Movie.all_ratings.map {|r| [r,r]}]

    @movies = 
    Movie.order(sort_column + " " + sort_direction).filter(checked_ratings)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private

  def sort_column
    session[:sort] ||= "title"

    if params.has_key?(:sort)
      if Movie.column_names.include?(params[:sort])
        session[:sort] = params[:sort]
      else
        session[:sort]
      end
    else
      session[:sort]
    end
  end

  def sort_direction
    session[:direction] ||= "asc"

    if params.has_key?(:direction)
      if %w[asc desc].include?(params[:direction])
        session[:direction] = params[:direction]
      else
        session[:direction]
      end
    else
      session[:direction]
    end
  end

  def checked_ratings
    session[:ratings] ||= @all_ratings

    if params[:ratings] == nil
      session[:ratings]
    elsif session[:ratings] == params[:ratings] 
      session[:ratings]
    else
      params[:ratings].each_value do |rating|
        rating = nil unless @all_ratings.has_value?(rating)
      end
      session[:ratings] = params[:ratings] 
    end
  end
end