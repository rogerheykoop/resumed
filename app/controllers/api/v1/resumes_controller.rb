class Api::V1::ResumesController < Api::V1::BaseController
  before_action :set_resume, only: [:show,:update, :destroy]
  load_and_authorize_resource

  include ActiveHashRelation

  api :GET, "/v1/users/:user_id/resumes/:id", "Get resume"
  description <<-EOS
  == Get all users
  Get an array of all users and their data.
  EOS
  formats ['json']
  def show
    if can? :read, Resume
      render(json: Api::V1::ResumeSerializer.new(@resume).to_json)
    end
  end

  api :POST, "/v1/users/:user_id/resumes", "Create resume"
  param :name, String, :desc => "Name", :required => false
  formats ['json']
  def create
    if can? :create, Resume
      @resume = Resume.new(resume_params)
      if !current_user.has_role?(:admin)
        @resume[:user_id] = current_user.id
      end
      if @resume.save
        render(json: Api::V1::ResumeSerializer.new(@resume).to_json)
      else
        render :json => { :errors => @resume.errors.full_messages }
      end
    end
  end

  api :PUT, "/v1/users/:user_id/resumes/:id", "Update resume"
  param :name, String, :desc => "Name", :required => false
  formats ['json']
  def update
    if can? :update, Resume
      if @resume.update(resume_params)
        render(json: Api::V1::ResumeSerializer.new(@resume).to_json)
      else
        render :json => { :errors => @resume.errors.full_messages }
      end
    end
  end

  api :DELETE, "/v1/users/:user_id/resumes/:id", "Create resume"
  formats ['json']
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
