class StatBlocksController < ApplicationController
  before_action :set_stat_block, only: [:show, :update, :destroy]

  # GET /stat_blocks
  # take parameter to find by ond order by
  def index
    @stat_blocks = StatBlock.all

    render json: @stat_blocks
  end

  # GET /stat_blocks/1
  # take parameter to find by ond order by
  def show
    render json: @stat_block
  end

  # POST /stat_blocks
  def create
    @stat_block = StatBlock.new(stat_block_params)

    if @stat_block.save
      render json: @stat_block, status: :created, location: @stat_block
    else
      render json: @stat_block.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /stat_blocks/1
  def update
    if @stat_block.update(stat_block_params)
      render json: @stat_block
    else
      render json: @stat_block.errors, status: :unprocessable_entity
    end
  end

  # DELETE /stat_blocks/1
  def destroy
    @stat_block.destroy
  end

  #Bulk delete
  def bulk_destroy
    @stat_block = StatBlock.destroy(params[:ids])
    render json: @stat_block
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stat_block
      @stat_block = StatBlock.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def stat_block_params
      params.require(:stat_block).permit(:name, :armor_class, :hit_points, :speed, :str, :dex, :con, :int, :wis, :cha, :saving_throws, :skills, :damage_resistance, :condition_immunities, :damage_immunities, :senses, :languages, :challenge_rating, :experience_points, :abilities, :actions, :legendary_actions, :creature_type, :alignment, :vulnerability)
    end
end
