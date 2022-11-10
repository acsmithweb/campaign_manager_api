class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :update, :destroy]

  # GET /items
  def index
    case params[:search_param]
    when 'id'
      @items = Item.find(params[:search_values])
    when 'text'
      @items = Item.search(params[:search_values])
    when nil
      @items = Item.all
    end
    render json: @items
  end

  # GET /items/1
  def show
    render json: @item
  end

  # POST /items
  def create
    @item = Item.new(item_params)

    if @item.save
      render json: @item, status: :created, location: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/1
  def update
    if @item.update(item_params)
      render json: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /items/1
  def destroy
    @item.destroy
  end

  def bulk_destroy
    @item = Item.destroy(params[:ids])
    render json: @item
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def item_params
      params.permit(:name, :details, :item_type, :magic, :ac, :weight, :value, :damage, :property, :dmg_type, :desc, :stealth, :rolls)
    end
end
