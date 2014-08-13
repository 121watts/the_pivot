class CategoriesController < ApplicationController
	def index
		@categories = Category.all
	end

	def edit
		@category = Category.find(params[:id])
	end

	def update
		@category = Category.find(params[:id])
		if @category.update(category_params)
			redirect_to categories_path
		else
			render :edit
		end
	end

	def new
		@category = Category.new
	end

	def create 
		Category.create(category_params)
		redirect_to categories_path
	end

	def destroy
		Category.find(params[:id]).destroy
		redirect_to categories_path
	end

	private

	def category_params
		params.require(:category).permit(:name)
	end
end