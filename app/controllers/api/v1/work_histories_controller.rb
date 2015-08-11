class Api::V1::WorkHistoriesController < Api::V1::BaseController
  before_action :set_work_history, only: [:show,:update, :destroy]
  load_and_authorize_resource

  include ActiveHashRelation

  def show
    if can? :read, WorkHistory
      render(json: Api::V1::WorkHistorySerializer.new(@work_history).to_json)
    end
  end

  def create
    if can? :create, WorkHistory
      if current_user.has_role?(:admin)
        # admin can add to any resume
        @resume = Resume.find(work_history_params[:resume_id])
      else
        # user can only add to own resumes
        @resume = Resume.where(["resume_id=? and user_id = ?",work_history_params[:resume_id],current_user.id])
      end
      if @work_history = @resume.work_histories.create(work_history_params)
        render(json: Api::V1::WorkHistorySerializer.new(@work_history).to_json)
      else
        render :json => { :errors => @work_history.errors.full_messages }
      end
    end
  end

  def update
    if can? :update, WorkHistory
      if current_user.has_role?(:admin) or (current_user.has_role?(:user) and @work_history.resume.user.id == current_user.id)
        if @work_history.update(work_history_params)
          render(json: Api::V1::WorkHistorySerializer.new(@work_history).to_json)
        else
          render :json => { :errors => @work_history.errors.full_messages }
        end
      else
        render :json => { :error => "This is not allowed" }
      end
    end
  end

  def destroy
    if can? :destroy, WorkHistory
      if current_user.has_role?(:admin) or (current_user.has_role?(:user) and @work_history.resume.user.id == current_user.id)
        if @work_history.destroy
          render :json => { :succes => "work_history destroyed" }
        else
          render :json => { :errors => @work_history.errors.full_messages }
        end
      else
        render :json => { :error => "This is not allowed" }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_work_history
    @work_history = WorkHistory.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def work_history_params
    params.require(:work_history).permit(:name,:user_id)
  end


end
