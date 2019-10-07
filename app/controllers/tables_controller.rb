class TablesController < ApplicationController
  def index
    @tables = Table.page(params[:page]).per Settings.pagenate_tables
  end

  def new
    @table = Table.new
  end

  def create
    @table = Table.new table_params
    if @table.save
      flash[:success] = t "create_table_suc"
      redirect_to tables_path
    else
      render :new
    end
  end

  private

  def table_params
    params.require(:table).permit Table::TABLE_PARAMS
  end
end
