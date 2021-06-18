class SpellsController < ApplicationController
  before_action :set_spell, only: [:show, :update, :destroy]

  # GET /spells
  def index
    case params[:search_param]
    when 'id'
      @spells = Spell.find(params[:search_values])
    when 'text'
      @spells = Spell.search(params[:search_values])
    when nil
      @spells = Spell.all
    end
    render json: @spells
  end

  # GET /spells/1
  def show
    render json: @spell
  end

  # POST /spells
  def create
    @spell = Spell.new(spell_params)

    if @spell.save
      render json: @spell, status: :created, location: @spell
    else
      render json: @spell.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /spells/1
  def update
    if @spell.update(spell_params)
      render json: @spell
    else
      render json: @spell.errors, status: :unprocessable_entity
    end
  end

  # DELETE /spells/1
  def destroy
    @spell.destroy
  end

  def bulk_destroy
    @spell = Spell.destroy(params[:ids])
    render json: @spell
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spell
      @spell = Spell.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def spell_params
      params.permit(:name, :desc, :higher_level, :range, :components, :material, :ritual, :duration, :concentration, :casting_time, :level, :attack_type, :damage_at_slot_level, :school, :classes, :dc, :area_of_effect, :damage_type)
    end
end
