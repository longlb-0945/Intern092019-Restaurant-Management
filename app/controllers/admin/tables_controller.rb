class Admin::TablesController < AdminController
  before_action :check_admin, except: %i(index show)
  before_action :load_table, except: %i(index new create sort)

  def index
    @tables = Table.send(order_key).page(params[:page])
                   .per Settings.pagenate_tables
  end

  def new
    @table = Table.new
  end

  def create
    @table = Table.new table_params
    if @table.save
      flash[:success] = t "create_table_suc"
      redirect_to admin_tables_path(action_update: "create")
    else
      flash.now[:danger] = t "create_table_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @table.update table_params
      flash[:success] = t "update_table_suc"
      redirect_to admin_tables_path(action_update: "update")
    else
      flash.now[:danger] = t "update_table_fail"
      render :edit
    end
  end

  def show
    respond_to :js
  end

  def destroy
    table_occupied
    if @table.send("#{params[:table_action]}!")
      flash[:success] = t "update_table_suc"
    else
      flash[:danger] = t "update_table_fail"
    end
    redirect_to admin_tables_path(action_update: "update")
  end

  def sort
    if Table::ORDER_SORT_HASH.values.include? params[:sort]
      @tables = Table.send(params[:sort])
                     .page(params[:page]).per Settings.pagenate_tables
      render :index
    else
      flash[:danger] = t "sort_param_fail"
      redirect_to admin_tables_path
    end
  end

  private
  def table_params
    params.require(:table).permit Table::TABLE_PARAMS
  end

  def load_table
    @table = Table.find_by id: params[:id]
    return if @table

    flash[:danger] = t "table_not_found"
    redirect_to admin_tables_path
  end

  def table_occupied
    return unless @table.occupied?

    flash[:danger] = "#{I18n.t('occupied')}!!!"
    redirect_to admin_tables_path
  end

  def order_key
    if params[:action_update].eql?("update")
      :updated_at_desc
    elsif params[:action_update].eql?("create")
      :created_at_desc
    else
      :order_status
    end
  end
end
