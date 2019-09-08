class SertsController < ApplicationController
  before_action :set_drug, only: [:create, :destroy]
  before_action :set_sert, only: [:destroy]
  before_action :set_invoice, only: [:destroy]

  def create
    @new_sert = @drug.serts.build(sert: file)

    if @new_sert.save
      redirect_to @drug, notice: 'Serts has been added'
    else
      render 'drug/show', alert: 'Serts has not been added'
    end
  end

  def destroy
    @sert.destroy
    redirect_to invoice_drug_path(@invoice, @drug), notice: 'Sert was successfully destroyed.'
  end

  private
    def set_sert
      @sert = @drug.serts.find_by(params[:id])
    end

    def set_drug
      @drug = Drug.find_by(token: params[:drug_token])
    end

    def set_invoice
      @invoice = Invoice.find_by(token: params[:invoice_token])
    end

    def sert_params
      params.require(:sert).permit(:sert, :drug_token)
    end
end
