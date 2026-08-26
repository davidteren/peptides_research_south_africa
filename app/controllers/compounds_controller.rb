class CompoundsController < ApplicationController
  def index
    @compounds = Compound.public_index.order(:name)
  end

  def show
    @compound = Compound.public_index.find_by!(slug: params[:id])
    @products = @compound.products.includes(:provider).order(:title_on_page)
  end
end
