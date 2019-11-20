class TablesController < ApplicationController
  def index
    @tables = Table.not_disable.page(params[:page]).per Settings.pagenate_tables
  end
end
