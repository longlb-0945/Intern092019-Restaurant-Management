class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

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
  has_one_attached :image

  SCOPE_SORT.each do |s|
    s_split = s.split("_")
    scope s, ->{order "#{s_split[0]} #{s_split[1]}"}
  end
  scope :created_at_desc, ->{order created_at: :desc}
  scope :created_at_asc, ->{order created_at: :asc}
  scope :default, ->{order id: :asc}
  scope :role_asc, ->{order role: :asc}
  scope :search,
        ->(data){where "name LIKE ? or email LIKE ?", "%#{data}%", "%#{data}%"}

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
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated? token
    return false if remember_digest.blank?

    BCrypt::Password.new(remember_digest).is_password? token
  end

  def forget
    update remember_digest: nil
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.expired_time.hour.ago
  end

  private

  def downcase_email
    email.downcase!
  end
end
