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

    session[:sort] ||= 'title';
    session[:ratings] ||= {"G" => 1, "PG" => 1, "PG-13" => 1, "R" => 1};


    # Instantiate variables
    @on = {"G" => true, "PG" => true, "PG-13" => true, "R" => true}
    @title_class = ''
    @date_class = ''
    @all_ratings = Movie.get_all_ratings
    redir = false

    # Choose which action to perform
    if !params.has_key?(:ratings)
      params[:ratings] = session[:ratings]
      redir = true
    end  
    if !params.has_key?(:sort)
      params[:sort] = session[:sort]
      redir = true
    end
    # if redir
    #   redirect_to movies_path(params)
    # else
      sort_data
      restrict
      @movies = Movie.with_ratings(@requested_ratings).order(params[:sort])
    # end

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
    
    @sort = (params[:sort])

    # Change color of column header that was selected
    if @sort == 'title'
      @title_class = 'hilite'
      @date_class = ''
    elsif @sort == 'release_date'
      @title_class = ''
      @date_class = 'hilite'
    else
      @title_class = ''
      @date_class = ''
    end 
    session[:sort] = params[:sort]
  end

  def restrict
    # Load requested ratings into array
    @requested_ratings = params[:ratings].keys

    # Create hash of ratings which remembers which checkboxes to keep on
    for x in @all_ratings
      if (!@requested_ratings.include? x)
        @on[x] = false
      end
    end

    
    session[:ratings] = params[:ratings]
  end


end
