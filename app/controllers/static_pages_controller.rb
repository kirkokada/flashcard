class StaticPagesController < ApplicationController
  def home
    if signed_in?
  	  @deck = current_user.decks.build
		  @decks = current_user.decks.paginate(page: params[:page], per_page: 10)

      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
