class MoviesController < ApplicationController
  helper_method :sort_column, :sort_direction, :checked_ratings

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort = params[:sort] || session[:sort]

    @all_ratings = Movie.all_ratings
    
    @selected_ratings = params[:ratings] || session[:ratings]
    @selected_ratings ||= Hash[@all_ratings.map {|r| [r,r]}]
   
    if params[:sort] != session[:sort] || params[:ratings] != session[:ratings]
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      redirect_to :sort => sort, :ratings => @selected_ratings
    else
      @movies = 
      Movie.order(sort_column + " " + sort_direction).filter(checked_ratings)
    end

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
    Movie.column_names.include?(params[:sort]) ? params[:sort] : "title"
    #if Movie.column_names.include?(params[:sort])
    #  session[:sort] = params[:sort]
    #else
    #  session[:sort]= "title"
    #end
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    #if %w[asc desc].include?(params[:direction])
      #session[:direction] = params[:direction]
    #else
     # session[:direction] = "asc"
   # end
  end

  def checked_ratings
    ratings = Array.new
    @selected_ratings.each do |rating|
      if Movie.all_ratings.include?(rating)
        ratings << rating 
        #session[:ratings] = ratings
      end
    end
  end
end