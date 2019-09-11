class DrugsController < ApplicationController
  before_action :set_drug, only: [:show, :edit, :update, :destroy, :download]

  def index
    @drugs = Drug.all
  end

  def show
    if @drug.present?
      @new_sert = @drug.serts.build(params[:sert])

    else
      redirect_to :root, notice: "The drug wasn't found."
    end
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

  def download
    @drug.zip_serts
    file = File.open('public/test.zip')

    send_file file
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
      @drug = Drug.find_by(token: params[:token])
    end

    def drug_params
      params.require(:drug).permit(:token)
    end
end
