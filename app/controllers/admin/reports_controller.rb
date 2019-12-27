require 'date'

class Admin::ReportsController < AdminController
  before_action :check_report_param, only: :report
  def index
    report_date = DateTime.now
    @reports = Order.paid.where("day(start_time) BETWEEN ? AND ?", report_date.day, report_date.day)
  end

  def report
    split_date = params[:report_date].split("/")
    if split_date.length == 2
      # month, "01/2019"
      @report_month = DateTime.new(split_date[1].to_i, split_date[0].to_i)
      @reports = Order.paid.where("start_time BETWEEN ? AND ?", @report_month.beginning_of_month, @report_month.end_of_month)
    elsif split_date.length == 3
      # day, "02/01/2019"
      @report_date = DateTime.new(split_date[2].to_i, split_date[1].to_i, split_date[0].to_i)
      @reports = Order.paid.where("start_time BETWEEN ? AND ?", @report_date.beginning_of_day, @report_date.end_of_day)
    else
      flash[:danger] = "Params invalid! Try again!"
      redirect_to admin_reports_path
    end
    render :index
  end

  def export_xsl
    split_date = params[:data].split("/")

    if split_date.length == 2
      # month, "01/2019"
      @report_month = DateTime.new(split_date[1].to_i, split_date[0].to_i)
      @reports = Order.paid.where("start_time BETWEEN ? AND ?", @report_month.beginning_of_month, @report_month.end_of_month)
    elsif split_date.length == 3
      # day, "02/01/2019"
      @report_date = DateTime.new(split_date[2].to_i, split_date[1].to_i, split_date[0].to_i)
      @reports = Order.paid.where("start_time BETWEEN ? AND ?", @report_date.beginning_of_day, @report_date.end_of_day)
    else
      flash[:danger] = "Params invalid! Try again!"
      redirect_to admin_reports_path
    end

    render xlsx: "admin/reports/export_xsl.xlsx.axlsx", filename: "Report"
    # respond_to do |format|
    #   format.html
    #   format.xlsx
    # end
  end

  private
  def check_report_param
    return unless params[:report_date].blank?

    flash[:danger] = "No data to process!"
    redirect_to admin_reports_path
  end
end
