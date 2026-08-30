class CompoundsController < ApplicationController
  def index
    @compounds = Catalog::CompoundBrowse.new(browse_params).records
  end

  def show
    @compound = Compound.public_index.find_by!(slug: params[:id])
    @products = @compound.products.includes(:provider).order(:title_on_page)
  end

  private
    def browse_params
      params.permit(:q, :route, :form, :classification, :provider_kind)
    end
end
