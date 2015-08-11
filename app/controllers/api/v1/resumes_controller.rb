class Api::V1::ResumesController < Api::V1::BaseController
  before_action :set_resume, only: [:show,:update, :destroy]
  load_and_authorize_resource

  include ActiveHashRelation

  def show
    if can? :read, Resume
        render(json: Api::V1::ResumeSerializer.new(@resume).to_json)
    end
  end

  def create
    if can? :create, Resume
      if @resume = current_user.resumes.create(resume_params)
        render(json: Api::V1::ResumeSerializer.new(@resume).to_json)
      else
        render :json => { :errors => @resume.errors.full_messages }
      end
    end
  end

  def update
    if can? :update, Resume
      if @resume.update(resume_params)
        render(json: Api::V1::ResumeSerializer.new(@resume).to_json)
      else
        render :json => { :errors => @resume.errors.full_messages }
      end
    end
  end

  def destroy
    if can? :destroy, Resume
      if @resume.destroy
        render :json => { :succes => "resume destroyed" }
      else
        render :json => { :errors => @resume.errors.full_messages }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_resume
    @resume = Resume.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def resume_params
    params.require(:resume).permit(:name,:user_id)
  end


end
