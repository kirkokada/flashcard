class CardsController < ApplicationController
	before_filter :signed_in_user
	
	def new
		@card = current_deck.cards.new
	end

	def create
		@card = current_deck.cards.build(params[:card])
		@card.next_review = Time.now
		if @card.save
			redirect_to edit_deck_path(current_deck)
			flash[:success] = "Card created."
		else
			render 'new'
		end
	end

	def edit
		@card = current_deck.cards.find(params[:id])
	end

	def update
		@card = current_deck.cards.find(params[:id])
		if @card.update_attributes(params[:card])
			@card.next_review = Time.now
			@card.save
			redirect_to edit_deck_path(current_deck)
			flash[:success] = "Card updated."
		else
			render 'edit'
		end
	end
end
