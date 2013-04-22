class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable  :registerable,
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  before_create :grand_access_to_ftp

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  # include Devise::Async::Model
  has_one :profile
  has_many :reports
  has_many :subscriptions

  belongs_to :center
  has_many :assets, :as => :attachable

  def admin?
    %w(antiqe@gmail.com lockerr@mail.ru).include?(email)
  end

  def is_admin?
    %w(antiqe@gmail.com lockerr@mail.ru).include?(email)
  end


  def grand_access_to_ftp
    begin
      user = Ftp::User.new
      user.userid = email
      user.passwd = ActiveRecord::Base.connection.execute("SELECT PASSWORD('#{password}')").first[0]
      user.save!
    end

  end

  def company_name
    center.name if center
  end




end
