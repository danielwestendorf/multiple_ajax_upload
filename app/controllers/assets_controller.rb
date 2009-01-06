class AssetsController < ApplicationController
  # GET /assets
  # GET /assets.xml
  def index
    @assets = Asset.primary.find(:all)
    session[:upload] = nil #reset the session[:upload] variable

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assets }
    end
  end

  # GET /assets/1
  # GET /assets/1.xml
  def show
    @asset = Asset.find(params[:id])
    session[:upload] = nil #reset the session[:upload] variable

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @asset }
    end
  end

  # GET /assets/new
  # GET /assets/new.xml
  def new
    session[:upload] ||= 0 #if there isn't a session[:upload] variable set, set it to 0. This variable is reset when the index or show actions are called to reset the form
    @asset = Asset.new
    @count = session[:upload] #make the count availabe to the view. We will use this to identify which form has submited the post, which tells us form to respond to

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @asset }
      format.js do
        session[:upload] += 1 #increment the count. This happens every time the new action is called (ie the 'add upload' button is clicked)
        @count = session[:upload] #update the @count variable
        render :action => 'add_asset.js.rjs'
      end
    end
  end

  # GET /assets/1/edit
  def edit
    @asset = Asset.find(params[:id])
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
              page.replace_html form, "Asset Uploaded!" #replace the correct form with some simple text
            end
          end
        end
      else
        error = "error"+params[:form].to_s #identify the correct error div id for the form
        format.html { render :action => "new" }
        format.js do
          responds_to_parent do
            render :update do |page|
              page.replace_html error, "#{error_messages_for :asset}"
            end
          end
        end
      end
    end
  end

  # PUT /assets/1
  # PUT /assets/1.xml
  def update
    @asset = Asset.find(params[:id])

    respond_to do |format|
      if @asset.update_attributes(params[:asset])
        flash[:notice] = 'Asset was successfully updated.'
        format.html { redirect_to(@asset) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @asset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /assets/1
  # DELETE /assets/1.xml
  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy

    respond_to do |format|
      format.html { redirect_to(assets_url) }
      format.xml  { head :ok }
    end
  end
end
