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
      #redirect_to 'invoice/index', notice: "The invoice wasn't found."
    end
  end

  def new
    @invoice = Invoice.new
  end

  def edit
  end

  def create
    invoice_params[:number] = change_lat_letters_in_number

    @invoice = Invoice.new(invoice_params)

    render :index and return unless @invoice.valid?

    @invoice_found = Invoice.find_by(invoice_params)

    if @invoice_found.present?
      @invoice_found.increment!(:counter, 1)

      redirect_to @invoice_found and return
    else
      flash.now[:alert] = I18n.t('controllers.invoices.error')
    end
    render :index
  end


  private

    def set_invoice
      @invoice = Invoice.find_by(token: params[:token])
    end


    def invoice_params
      params.require(:invoice).permit(:token, :number, :inn, :date)
    end

    def change_lat_letters_in_number
      letters = {'M' => 'М', 'P' => 'Р'}
      invoice_params[:number].upcase!
      invoice_params[:number].gsub!(/M|P/, letters)
      invoice_params
    end
end

