class TablesController < ApplicationController
  before_action :load_table, except: %i(index new create)

  def index
    @tables = Table.order_number.page(params[:page])
                   .per Settings.pagenate_tables
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
      flash[:danger] = t "create_table_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @table.update table_params
      flash[:success] = t "update_table_suc"
      redirect_to tables_path
    else
      flash[:danger] = t "update_table_fail"
      render :edit
    end
  end

  def show
    respond_to :js
  end

  private
  def table_params
    params.require(:table).permit Table::TABLE_PARAMS
  end

  def load_table
    @table = Table.find_by id: params[:id]
    return if @table

    flash[:danger] = t "table_not_found"
    redirect_to tables_path
  end
end
