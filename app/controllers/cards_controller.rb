class CardsController < ApplicationController
	before_filter :signed_in_user
	
	def new
		@card = current_deck.cards.new
	end

	def create
		@card = current_deck.cards.build(params[:card])
		if @card.save
			redirect_to edit_deck_path(current_deck)
			flash[:success] = "Card created."
		else
			render 'new'
		end
	end

	def edit
		@card = Card.find(params[:id])
	end

	def update
		@card = Card.find(params[:id])
		if @card.update_attributes(params[:card])
			@card.next_review = Time.now
			@card.save
			redirect_to edit_deck_path(@card.deck_id)
			flash[:success] = "Card updated."
		else
			render 'edit'
		end
	end

	def show
		@card = Card.find(params[:id])
	end

	def destroy
		@card = Card.find(params[:id])
		@deck = Deck.find(@card.deck_id)
		@card.destroy
		flash[:success] = "Card destroyed."
		redirect_to edit_deck_path(@deck)
	end
end
