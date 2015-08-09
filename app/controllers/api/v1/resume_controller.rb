class Api::V1::ResumesController < Api::V1::BaseController

  include ActiveHashRelation

  def show
    resume = Resume.find(params[:id])

    render(json: Api::V1::ResumeSerializer.new(resume).to_json)
  end

end
