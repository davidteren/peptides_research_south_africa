class StacksController < ApplicationController
  def index
    @stacks = Stack.public_index.order(:name)
  end

  def show
    @stack = Stack.public_index.find_by!(slug: params[:id])
    @compounds = stack_members(@stack)
    @result = Catalog::StackChecker.new(@compounds).result
  end

  def new
    @compounds = Compound.public_index.order(:name)
  end

  def check
    slugs = Array(params[:compound_ids]).map(&:to_s)
    @compounds = Compound.public_index.where(slug: slugs).to_a.sort_by { |compound| slugs.index(compound.slug) || slugs.size }
    @result = Catalog::StackChecker.new(@compounds).result
  end

  private
    def stack_members(stack)
      ids = Array(stack.payload&.dig("compound_ids"))
      Compound.public_index.where(slug: ids).to_a.sort_by { |compound| ids.index(compound.slug) || ids.size }
    end
end
