class Api::V1::EducationHistoriesController < Api::V1::BaseController
  before_action :set_education_history, only: [:show,:update, :destroy]
  load_and_authorize_resource :user
  load_and_authorize_resource :resume, :through => :user,:shallow=>true
  load_and_authorize_resource :education_history, :through => :resume,:shallow=>true

  include ActiveHashRelation

  def_param_group :education_history do
    param :education, String, :desc => "Education (type of education) ", :required => false
    param :from, String, :desc => "From (date description, 04/12/2001 for instance) ", :required => false
    param :until, String, :desc => "Until (date description, 04/12/2001 for instance), should be greater than from date ", :required => false
    param :school_name, String, :desc => "Name of the school ", :required => false
  end

  api :GET, "/v1/users/:user_id/resumes/:resume_id/education_histories/:id", "Get education_history data"
  formats ['json']
  def show
    if can? :read, EducationHistory
      render(json: Api::V1::EducationHistorySerializer.new(@education_history).to_json)
    end
  end

  api :POST, "/v1/users/:user_id/resumes/:resume_id/education_histories", "add new education_history data to resume"
  param_group :education_history
  formats ['json']
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

  api :PUT, "/v1/users/:user_id/resumes/:resume_id/education_histories/:id", "Update education_history data"
  param_group :education_history
  formats ['json']
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

  api :DELETE, "/v1/users/:user_id/resumes/:resume_id/education_histories/:id", "Delete education_history data"
  formats ['json']
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
    params.require(:education_history).permit(:resume_id,:from,:until,:school_name,:education)
  end


end
