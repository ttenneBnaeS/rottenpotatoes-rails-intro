class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    # Instantiate variables
    @on = {"G" => true, "PG" => true, "PG-13" => true, "R" => true}
    puts @on
    @title_class = ''
    @date = ''
    @all_ratings = Movie.get_all_ratings

    # Choose which action to perform
    if params.has_key?(:ratings)
      restrict
    elsif params.has_key?(:sort)
      sort_data
    else
      @movies = Movie.all
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def sort_data

    # Sort movies based on selected sort condition
    @movies = Movie.order(params[:sort])
    @sort = (params[:sort])

    # Change color of column header that was selected
    if @sort == 'title'
      @title_class = 'hilite'
      @date = ''
    else
      @title_class = ''
      @date = 'hilite'
    end 
  end

  def restrict
    # Load requested ratings into array
    requested_ratings = params[:ratings].keys

    # Create hash of ratings which remembers which checkboxes to keep on
    for x in @all_ratings
      if (!requested_ratings.include? x)
        @on[x] = false
      end
    end

    @movies = Movie.with_ratings(requested_ratings)
  end


end
