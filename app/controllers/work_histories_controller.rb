class WorkHistoriesController < ApplicationController
  before_action :set_work_history, only: [:show, :edit, :update, :destroy]

  # GET /work_histories
  # GET /work_histories.json
  def index
    @work_histories = WorkHistory.all
  end

  # GET /work_histories/1
  # GET /work_histories/1.json
  def show
  end

  # GET /work_histories/new
  def new
    @work_history = WorkHistory.new
  end

  # GET /work_histories/1/edit
  def edit
  end

  # POST /work_histories
  # POST /work_histories.json
  def create
    @work_history = WorkHistory.new(work_history_params)

    respond_to do |format|
      if @work_history.save
        format.html { redirect_to @work_history, notice: 'Work history was successfully created.' }
        format.js   { render }
        format.json { render :show, status: :created, location: @work_history }
      else
        format.html { render :new }
        format.json { render json: @work_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /work_histories/1
  # PATCH/PUT /work_histories/1.json
  def update
    respond_to do |format|
      if @work_history.update(work_history_params)
        format.html { redirect_to @work_history, notice: 'Work history was successfully updated.' }
        format.json { render :show, status: :ok, location: @work_history }
      else
        format.html { render :edit }
        format.json { render json: @work_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /work_histories/1
  # DELETE /work_histories/1.json
  def destroy
    @work_history.destroy
    respond_to do |format|
      format.html { redirect_to work_histories_url, notice: 'Work history was successfully destroyed.' }
      format.js   { render }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work_history
      @work_history = WorkHistory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def work_history_params
      params.require(:work_history).permit(:resume_id,:position,:from,:until,:company_name)
    end
end
