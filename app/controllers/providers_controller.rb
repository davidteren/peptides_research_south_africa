class ProvidersController < ApplicationController
  def index
    @providers = Provider.public_index.order(:name)
  end

  def show
    @provider = Provider.public_index.find_by!(slug: params[:id])
    @products = Catalog::ListingOrder.new(@provider.products.includes(:compound)).records
  end
end
