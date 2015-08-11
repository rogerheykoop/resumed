class Api::V1::WorkHistoriesController < Api::V1::BaseController
  before_action :set_work_history, only: [:show,:update, :destroy]
  load_and_authorize_resource :user
  load_and_authorize_resource :resume, :through => :user,:shallow=>true
  load_and_authorize_resource :work_history, :through => :resume,:shallow=>true

  include ActiveHashRelation

  def show
    if can? :read, WorkHistory
      render(json: Api::V1::WorkHistorySerializer.new(@work_history).to_json)
    end
  end

  def create
    if can? :create, WorkHistory
      @work_history = WorkHistory.new(work_history_params)
      if current_user.has_role?(:admin)
        # admin can add to any resume
        @resume = Resume.find(params[:resume_id])
      else
        # user can only add to own resumes
        @resume = Resume.where(["id=? and user_id = ?",params[:resume_id],current_user.id]).first
      end
      if !@resume.nil? and @work_history.save!
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
      if @work_history.destroy
        render :json => { :succes => "work_history destroyed" }
      else
        render :json => { :errors => @work_history.errors.full_messages }
      end
    else
      render :json => { :error => "This is not allowed" }
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
