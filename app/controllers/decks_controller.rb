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

	def edit
		@deck = current_user.decks.find(params[:id])
		@cards = @deck.cards.paginate(page: 1, per_page: 10, order: "next_review DESC")
		session[:deck_id] = @deck.id #Saves deck to be passed to Card controller
	end

	def update
		@deck = current_user.decks.find(params[:id])
		if @deck.update_attributes(params[:deck])
			redirect_to root_path
			flash[:success] = "Deck updated!"
			session[:deck_id] = nil
		else
			render 'edit'
		end
	end

	def destroy
		# For some reason, paginate returns an ActiveRecord::Relation instead of a WillPaginate::Collection
		# so the next_page method does not work. @last_deck and @next_deck is a work around to this.
		@last_deck = current_user.decks.paginate(page: params[:page], per_page: 10).last  # last deck shown on the page BEFORE the target deck is destroyed
		current_user.decks.find(params[:id]).destroy
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
