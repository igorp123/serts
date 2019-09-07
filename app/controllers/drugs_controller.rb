class DrugsController < ApplicationController
  before_action :set_drug, only: [:show, :edit, :update, :destroy]

  def index
    @drugs = Drug.all
  end

  def show
    @new_sert = @drug.serts.build(params[:sert])
  end

  def new
    @drug = Drug.new
  end

  def edit
  end

  def create
    @drug = Drug.new(drug_params)

    if @drug.save
      redirect_to @drug, notice: 'Drug was successfully created.'
    else
      render :new
    end
  end

  def update
    respond_to do |format|
      if @drug.update(drug_params)
        format.html { redirect_to @drug, notice: 'Drug was successfully updated.' }
        format.json { render :show, status: :ok, location: @drug }
      else
        format.html { render :edit }
        format.json { render json: @drug.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @drug.destroy
    respond_to do |format|
      format.html { redirect_to drugs_url, notice: 'Drug was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_drug
      @drug = Drug.find(params[:id])
    end

    def drug_params
      params.fetch(:drug, {})
    end
end
