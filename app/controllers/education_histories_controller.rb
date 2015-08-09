class EducationHistoriesController < ApplicationController
  before_action :set_education_history, only: [:show, :edit, :update, :destroy]

  # GET /education_histories
  # GET /education_histories.json
  def index
    @education_histories = EducationHistory.all
  end

  # GET /education_histories/1
  # GET /education_histories/1.json
  def show
  end

  # GET /education_histories/new
  def new
    @education_history = EducationHistory.new
  end

  # GET /education_histories/1/edit
  def edit
  end

  # POST /education_histories
  # POST /education_histories.json
  def create
    @education_history = EducationHistory.new(education_history_params)

    respond_to do |format|
      if @education_history.save
        format.html { redirect_to @education_history, notice: 'Education history was successfully created.' }
        format.js   { render }
        format.json { render :show, status: :created, location: @education_history }
      else
        format.html { render :new }
        format.json { render json: @education_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /education_histories/1
  # PATCH/PUT /education_histories/1.json
  def update
    respond_to do |format|
      if @education_history.update(education_history_params)
        format.html { redirect_to @education_history, notice: 'Education history was successfully updated.' }
        format.json { render :show, status: :ok, location: @education_history }
      else
        format.html { render :edit }
        format.json { render json: @education_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /education_histories/1
  # DELETE /education_histories/1.json
  def destroy
    @education_history.destroy
    respond_to do |format|
      format.html { redirect_to education_histories_url, notice: 'Education history was successfully destroyed.' }
      format.js   { render }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_education_history
      @education_history = EducationHistory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def education_history_params
      params.require(:education_history).permit(:resume_id,:school_name,:from,:until)
    end
end
