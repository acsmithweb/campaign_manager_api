class WorkbooksController < ApplicationController
  before_action :set_workbook, only: [:show, :update, :destroy]

  def index
    case params[:search_param]
    when 'id'
      @workbook = Workbook.find(params[:search_values]).map(&:to_frontend_json)
    when 'name'
      @workbook = Workbook.search(params[:search_values]).map(&:to_frontend_json)
    when nil
      @workbook = Workbook.all.map(&:to_frontend_json)
    end
    render json: @workbook
  end

  def show
  end

  def create
    @workbook = Workbook.create(name: params[:name], user_id: params[:user_id], notes: params[:notes])
    Spell.where(id: params[:bookmarkedSpells]&.map(&:to_i)).each do |spell|
      @workbook.add_record(spell)
    end
    Item.where(id: params[:bookmarkedItems]&.map(&:to_i)).each do |item|
      @workbook.add_record(item)
    end
    StatBlock.where(id: params[:bookmarkedCreatures]&.map(&:to_i)).each do |stat_block|
      @workbook.add_record(stat_block)
    end
    if @workbook.id.present?
      render json: @workbook, status: :created, location: @workbook
    else
      render json: @workbook.errors, status: :unprocessable_entity
    end
  end

  def update
    @workbook = set_workbook
    if @workbook.save
      render json: @workbook, status: :created, location: @workbook
    else
      render json: @workbook.errors, status: :unprocessable_entity
    end
  end

  def destroy
  end

  def bulk_destroy
  end

  private

  def set_workbook
    Woorkbook.exists?(id: params[:id]) ? (@workbook = Workbook.find(params[:id])) : workbook_not_found_error
  end

  def work_book_params
    params.permit(:name, :notes, :user_id, :bookmarkedSpells, :bookmarkedCreatures, :bookmarkedItems)
  end

  def workbook_not_found_error
    render json: {
      error:
      {
        status: '204',
        message: 'Resource Not Found'
      }
    }
  end
end
