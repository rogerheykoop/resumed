class Api::V1::EducationHistoriesController < Api::V1::BaseController
  before_action :set_education_history, only: [:show,:update, :destroy]
  load_and_authorize_resource :user
  load_and_authorize_resource :resume, :through => :user,:shallow=>true
  load_and_authorize_resource :education_history, :through => :resume,:shallow=>true

  include ActiveHashRelation

  api!
  def show
    if can? :read, EducationHistory
      render(json: Api::V1::EducationHistorySerializer.new(@education_history).to_json)
    end
  end

  api!
  def create
    if can? :create, EducationHistory
      @education_history = EducationHistory.new(education_history_params)
      if current_user.has_role?(:admin)
        # admin can add to any resume
        @resume = Resume.find(params[:resume_id])
      else
        # user can only add to own resumes
        @resume = Resume.where(["id=? and user_id = ?",params[:resume_id],current_user.id]).first
      end
      if !@resume.nil? and @education_history.save!
        render(json: Api::V1::EducationHistorySerializer.new(@education_history).to_json)
      else
        render :json => { :errors => @education_history.errors.full_messages }
      end
    end
  end

  api!
  def update
    if can? :update, EducationHistory
      if current_user.has_role?(:admin) or (current_user.has_role?(:user) and @education_history.resume.user.id == current_user.id)
        if @education_history.update(education_history_params)
          render(json: Api::V1::EducationHistorySerializer.new(@education_history).to_json)
        else
          render :json => { :errors => @education_history.errors.full_messages }
        end
      else
        render :json => { :error => "This is not allowed" }
      end
    end
  end

  api!
  def destroy
    if can? :destroy, EducationHistory
      if @education_history.destroy
        render :json => { :succes => "education_history destroyed" }
      else
        render :json => { :errors => @education_history.errors.full_messages }
      end
    else
      render :json => { :error => "This is not allowed" }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_education_history
    @education_history = EducationHistory.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def education_history_params
    params.require(:education_history).permit(:resume_id,:position,:from,:until,:school_name)
  end


end
