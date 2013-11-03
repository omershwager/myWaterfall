require 'fastimage'

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
  
  # GET /images#waterfallData.json
  def waterfallData
    showedWidth = 300

    @images = Image.order('created_at desc').all

    arr = Array.new;
    @images.each do |image|
      hash = Hash.new
      absoluteUrl = request.protocol + request.host_with_port + image.asset.url("large")
      hash["image"] = absoluteUrl

      # hash["image"] = URI.join(request.url, image.asset.url)
      hash["width"] = showedWidth
      showedHeight = showedWidth
      
      logger.info "image.image_width before: #{image.image_width}"
      logger.info "image.image_height before: #{image.image_height}"
      # if image.image_width.to_s.empty? or image.image_width == 0 or image.image_height.to_s.empty? or image.image_height == 0
        updateImageDimensions(image, absoluteUrl)
      # end
      logger.info "image.image_width after: #{image.image_width}"
      logger.info "image.image_height after: #{image.image_height}"
      if image.image_width and image.image_width != 0 and image.image_height and image.image_height != 0
        ratio = image.image_width.to_f / image.image_height
        logger.info "ratio: #{ratio}"
        showedHeight = Integer(showedWidth.to_f / ratio)
        logger.info "showedHeight: #{showedHeight}"
      end
      hash["height"] = showedHeight
      arr.push(hash)
    end

    res = Hash.new
    res["total"] = arr.length
    res["result"] = arr

    respond_to do |format|
      # maybe uncomment next line
      # format.html
      format.json { render json: res }          
    end
  end


  # GET /images#waterfall
  def mywaterfall
    respond_to do |format|
      format.html # show.html.erb      
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

  def updateImageDimensions(image,  absoluteUrl)
    begin
      logger.info "absoluteUrl: #{absoluteUrl}"
      logger.info "image: #{image}"
      dimentionsArr = Array.new;
      if absoluteUrl.match("localhost")
        localPath = image.asset.url("large")
        logger.info "localPath: #{localPath}"
        dimentionsArr = FastImage.size(localPath)
      else
        logger.info "attemptin FastImage.size from absoluteUrl: #{absoluteUrl}"
        dimentionsArr = FastImage.size(absoluteUrl)
      end
      logger.info "dimentionsArr: #{dimentionsArr}"
      image.image_width = dimentionsArr[0]
      image.image_height = dimentionsArr[1]  
      image.save    
    rescue
    end
  end

end
