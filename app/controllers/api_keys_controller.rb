class ApiKeysController < ApplicationController
  before_filter :must_be_user
  before_filter :must_own_key, :except => [:index, :create]

  # GET /api_keys
  # GET /api_keys.json
  def index
    @api_keys = ApiKey.find_all_by_user_id current_user.id
    @new_key = ApiKey.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @api_keys }
      format.json { render :json => @api_keys }
    end
  end

  # GET /api_keys/1
  # GET /api_keys/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @api_key }
      format.json { render :json => @api_key }
    end
  end

  # POST /api_keys
  # POST /api_keys.json
  def create
    @api_key = ApiKey.new(:user => current_user)
    respond_to do |format|
      if @api_key.save
        format.html { redirect_to(api_keys_url, :notice => 'Snippet was successfully created.') }
        format.xml  { render :xml => @api_key, :status => :created, :location => @api_key }
        format.json { render :json => @api_key, :status => :created, :location => @api_key }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @api_key.errors, :status => :unprocessable_entity }
        format.json { render :json => @api_key.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /api_keys/1
  # DELETE /api_keys/1.json
  def destroy
    @api_key.destroy

    respond_to do |format|
      format.html { redirect_to(api_keys_url) }
      format.xml  { head :ok }
      format.json { head :ok }
    end
  end

  protected
  def must_own_key
    @api_key = ApiKey.find(params[:id])
    unless @api_key.user == current_user
      flash[:notice] = "That key does not belong to you."
      redirect_to api_keys
      return false # Stop doing stuff
    end
    return true # continue to do stuff
  end
end
