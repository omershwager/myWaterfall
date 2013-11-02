class ImagesController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create, :destroy]
  before_filter :find_image, only: [:show, :destroy]
  # before_filter :add_breadcrumbs
  # todo: consider uncommenting:
  # rescue_from ActiveModel::MassAssignmentSecurity::Error, with: :render_permission_error

  # GET /images
  # GET /images.json
  def index
    @images = Image.order('created_at desc').all

    respond_to do |format|
      if !current_user
        flash.now[:notice] = 'You need to login if you want to add your own pics.'
      end 
      format.html
      format.json { render json: @images }          
    end
  end

  # GET /images/1
  # GET /images/1.json
  def show
    # maybe I need to uncomment this:
    # @image = Image.find(params[:id])    
    # add_breadcrumb @image, image_path(@image)  

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @image }
    end
  end

  # GET /images/new
  # GET /images/new.json
  def new
    # maybe I need the following instead ?
    #@image = current_user.images.new
    @image = Image.new    


    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @image }
    end
  end


  # POST /images
  # POST /images.json
  def create
    # maybe I need the following instead ?	
    #@image = current_user.images.new(params[:image])
    @image = Image.new(params[:image])
    
    respond_to do |format|
      if @image.save
        format.html { redirect_to images_path, notice: 'Image was successfully created.' }
	       # format.html { redirect_to images_path, notice: 'Image was successfully created.' }
        format.json { render json: images_path, status: :created, location: @image }
      else
        format.html { render action: "new" }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    # todo: maybe I should also have this uncommented instead of the next?
    # @image = current_user.images.find(params[:id])
    @image = Image.find(params[:id])
    @image.destroy

    respond_to do |format|
      format.html { redirect_to images_url }
      format.json { head :no_content }
    end
  end

  def url_options
    { profile_name: params[:profile_name] }.merge(super)
  end

  #  def add_breadcrumbs
    #  add_breadcrumb current_user.first_name, profile_path(current_user)
    #  add_breadcrumb "Images", images_path
  #  end

  def find_image
    @image = Image.find(params[:id])
  end

end
