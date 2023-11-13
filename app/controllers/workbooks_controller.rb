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
    @workbook = Workbook.create(name: params[:props][:name], user_id: params[:user_id], notes: params[:notes])
    puts params
    Spell.where(id: params[:props][:bookmarkedSpells]&.map(&:to_i)).each do |spell|
      puts spell.inspect
      @workbook.add_record(spell)
    end
    Item.where(id: params[:props][:bookmarkedItems]&.map(&:to_i)).each do |item|
      puts item.inspect
      @workbook.add_record(item)
    end
    StatBlock.where(id: params[:props][:bookmarkedCreatures]&.map(&:to_i)).each do |stat_block|
      puts stat_block.inspect
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
