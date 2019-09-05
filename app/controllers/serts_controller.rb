class SertsController < ApplicationController
  before_action :set_drug, only: [:create, :destroy]
  before_action :set_sert, only: [:destroy]

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
    redirect_to @drug, notice: 'Sert was successfully destroyed.'
  end

  private
    def set_sert
      @sert = @drug.serts.find(params[:id])
    end

    def set_drug
      @drug = Drug.find(params[:drug_id])
    end

    def sert_params
      params.fetch(:sert, {}).permit(:sert)
    end
end
