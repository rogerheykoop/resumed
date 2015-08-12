class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  has_many :resumes
  has_many :work_histories, through: :resumes
  has_many :education_histories, through: :resumes

  validates_format_of :email, :with => /@/

  after_create :set_default_role

  private
  def set_default_role
    self.add_role :user if self.roles.blank?
  end


end
