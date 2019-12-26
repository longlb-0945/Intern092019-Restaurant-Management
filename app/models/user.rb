class User < ApplicationRecord
  include Image

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  SCOPE_SORT = %w(name_asc name_desc email_asc
    email_desc status_asc status_desc).freeze

  enum role: {admin: 0, staff: 1, guest: 2}
  enum status: {enable: 0, disable: 1}
  enum sort_enum: {default: 0, name_asc: 1, name_desc: 2,
                   email_asc: 3, email_desc: 4, role_asc: 5, status_asc: 6,
                   status_desc: 7, created_at_asc: 8, created_at_desc: 9}

  has_many :rates, dependent: :nullify
  has_many :customer_orders, foreign_key: :customer_id,
    class_name: Order.name, dependent: :destroy,
    inverse_of: :customer
  has_many :staff_orders, foreign_key: :staff_id,
    class_name: Order.name, dependent: :destroy,
    inverse_of: :staff
  has_many :notifications
  has_one_attached :image

  SCOPE_SORT.each do |s|
    s_split = s.split("_")
    scope s, ->{order "#{s_split[0]} #{s_split[1]}"}
  end
  scope :created_at_desc, ->{order created_at: :desc}
  scope :created_at_asc, ->{order created_at: :asc}
  scope :default, ->{order id: :asc}
  scope :latest_members, (lambda do
    where("created_at >= ? AND role = ?",
          Settings.latest_record.days.ago, Settings.guest_role)
  end)
  scope :role_asc, ->{order role: :asc}

  VALID_EMAIL_REGEX = Settings.email_regex

  before_save :downcase_email

  validates :image, content_type: {in: %w(image/jpeg image/gif image/png),
                                   message: I18n.t("valid_type_img")},
    size: {less_than: Settings.imgsize5.megabytes,
           message: I18n.t("valid_size_img")}
  validates :name, presence: true,
    length: {maximum: Settings.maximum_name_length}
  validates :email, presence: true,
    length: {maximum: Settings.maximum_email_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end

    def new_with_session params, session
      super.tap do |user|
        if session["devise.facebook_data"]
          udata = session["devise.facebook_data"]["extra"]["raw_info"]
          fb_info = session["devise.facebook_data"]
          user.name = udata["name"] if user.name.blank?
          user.email = udata["email"] if user.email.blank?
          user.uid = fb_info["uid"] if user.uid.blank?
          user.provider = fb_info["provider"] if user.provider.blank?
        end
      end
    end
  end

  private
  def downcase_email
    email.downcase!
  end
end
