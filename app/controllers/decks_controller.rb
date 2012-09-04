class DecksController < ApplicationController
	before_filter :signed_in_user

	def create
		@deck = current_user.decks.build(params[:deck])
		if @deck.save
			respond_to do |format|
				format.html do 
					flash[:success] = "Deck created!"
					redirect_to root_url
				end
				format.js do
					@page = params[:page]
					unless @page === 1
						@decks = current_user.decks.paginate(page: 1, per_page: 10)
					end 
					flash.now[:success] = "Deck created!"
				end
			end
		else
			respond_to do |format|
				format.html { redirect_to root_path }
				format.js
			end
		end
	end

	def destroy
		# For some reason, paginate returns an ActiveRecord::Relation instead of a WillPaginate::Collection
		# so the next_page method does not work. @last_deck and @next_deck is a work around to this.
		# last deck shown on the page BEFORE the target deck is destroyed
		@last_deck = current_user.decks.paginate(page: params[:page], per_page: 10).last 
		Deck.find(params[:id]).destroy
		respond_to do |format|
			format.html do 
				flash[:success] = "Deck destroyed."
				redirect_to root_path
			end
			format.js do
				# last deck shown on the page AFTER the target deck is destroyed
				@next_deck = current_user.decks.paginate(page: params[:page], per_page: 10).last 
				flash.now[:success] = "Deck destroyed."
			end
		end
	end
end
