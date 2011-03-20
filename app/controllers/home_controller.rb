class HomeController < ApplicationController
  def index
    if current_user
      @snippets = Snippet.find_all_by_owner_id current_user.id
    else
      redirect_to :action => "about"
    end
  end

  def about
  end
end
