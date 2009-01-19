class AssetsController < ApplicationController
  # GET /assets
  # GET /assets.xml
  def index
    @assets = Asset.primary.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assets }
    end
  end

  # GET /assets/1
  # GET /assets/1.xml
  def show
    @asset = Asset.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @asset }
    end
  end

  # GET /assets/new
  # GET /assets/new.xml
  def new
    @asset = Asset.new
    @uuid = (0..29).to_a.map { |x| rand(10) } #the unique identifier for the form and the upload

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @asset }
      format.js do
        render :action => 'add_asset.js.rjs'
      end
    end
  end

  # POST /assets
  # POST /assets.xml
  def create
    @asset = Asset.new(params[:asset])

    respond_to do |format|
      if @asset.save
        form = "form" + params[:form].to_s #add the word 'form' and the form id that is passed in the form as a param
        format.html { redirect_to(@asset) }
        format.js do
          responds_to_parent do
            render :update do |page|
              page.insert_html :bottom, form, image_tag(@asset.public_filename(:thumb)) #replace the correct form with some simple text
            end
          end
        end
      else
        error = "error"+params[:form].to_s #identify the correct error div id for the form
        @uuid = (0..29).to_a.map { |x| rand(10) }
        format.html { render :action => "new" }
        format.js do
          responds_to_parent do
            render :update do |page|
              page.replace_html error, "#{error_messages_for :asset}" #insert the error messages
              page << "$('#uploading#{params[:form].to_s}').remove();"#remove the progress bar
              page << "$('input:disabled').removeAttr(\"disabled\");" #make it possible to select another file
            end
          end
        end
      end
    end
  end


  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy

    respond_to do |format|
      format.html { redirect_to(assets_url) }
      format.xml  { head :ok }
    end
  end
end
