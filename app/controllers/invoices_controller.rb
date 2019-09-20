class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]

  def index
    @invoices = Invoice.all
    @invoice = Invoice.new
  end

  def show
    if @invoice.present?
      @drugs = @invoice.drugs.order(:name)
    else
      redirect_to 'invoice/index', notice: "The invoice wasn't found."
    end
  end

  def new
    @invoice = Invoice.new
  end

  def edit
  end

  def create
    @invoice = Invoice.find_by(invoice_params)
    if @invoice.present?
      @invoice.increment!(:counter, 1)
      redirect_to @invoice
    else
      @invoice = Invoice.new(invoice_params)
      if @invoice.valid?
      else
      flash.now[:alert] = "The invoice wasn't found."
      render :index
    end
    end
  end


  private
    def set_invoice
      @invoice = Invoice.find_by(token: params[:token])
    end


    def invoice_params
      params.require(:invoice).permit(:token, :number, :inn, :date)
    end
end
