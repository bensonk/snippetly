class SnippetsController < ApplicationController
  before_filter :must_be_user, :except => :show
  skip_before_filter :verify_authenticity_token

  # GET /snippets
  # GET /snippets.xml
  def index
    @snippets = Snippet.find_all_by_owner_id current_user.id

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @snippets }
      format.json { render :json => @snippets }
    end
  end

  # GET /snippets/1
  # GET /snippets/1.xml
  def show
    @snippet = Snippet.find_by_id(params[:id])
    if params[:nick]
      requested_user = User.find_by_nick params[:nick]
    else
      requested_user ||= current_user # Default to current user if requested user isn't found
    end
    @snippet = Snippet.find_by_owner_id_and_name(requested_user.id, params[:id]) unless @snippet

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @snippet }
      format.json { render :json => @snippet }
      format.text { render :text => @snippet.body }
    end
  end

  # GET /snippets/new
  # GET /snippets/new.xml
  def new
    @snippet = Snippet.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @snippet }
      format.json { render :json => @snippet }
    end
  end

  # GET /snippets/1/edit
  def edit
    @snippet = Snippet.find(params[:id])
  end

  # POST /snippets
  # POST /snippets.xml
  def create
    @snippet = Snippet.new(params[:snippet])
    logger.info "Snippet created: #{@snippet}"
    if current_user
      @snippet.owner = current_user
    else
      @snippet.owner = nil
    end
    logger.info "User set: #{@snippet.owner}"

    respond_to do |format|
      if @snippet.save
        format.html { redirect_to(@snippet, :notice => 'Snippet was successfully created.') }
        format.xml  { render :xml => @snippet, :status => :created, :location => @snippet }
        format.json { render :json => @snippet, :status => :created, :location => @snippet }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @snippet.errors, :status => :unprocessable_entity }
        format.json { render :json => @snippet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /snippets/1
  # PUT /snippets/1.xml
  def update
    @snippet = Snippet.find(params[:id])

    respond_to do |format|
      if @snippet.update_attributes(params[:snippet])
        format.html { redirect_to(@snippet, :notice => 'Snippet was successfully updated.') }
        format.xml  { head :ok }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @snippet.errors, :status => :unprocessable_entity }
        format.json { render :json => @snippet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /snippets/1
  # DELETE /snippets/1.xml
  def destroy
    @snippet = Snippet.find_by_id(params[:id])
    @snippet = Snippet.find_by_owner_id_and_name(current_user.id, params[:id]) unless @snippet

    @snippet.destroy

    respond_to do |format|
      format.html { redirect_to(snippets_url) }
      format.xml  { head :ok }
      format.json { head :ok }
    end
  end
end
