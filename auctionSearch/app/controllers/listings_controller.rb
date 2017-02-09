class ListingsController < ApplicationController
	def create
		@Search = Search.find(params[:search_id])
		@listing = @search.listings.create(listing_params)
	end

	def update
		@search = Search.find(params[:search_id])
		@listing = @search.listings.find(params[:id])

		@listing.update(listing_params)
	end

	def destroy
		@search = Search.find(params[:search_id])
		@listing = @search.listings.find(params[:id])
		@listing.destroy
		redirect_to search_path(@search)
	end

	private
		def listing_params
			params.require(:listing).permit(:title, :url, :img)
		end
end
