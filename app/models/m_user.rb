class MUser < ApplicationRecord
  attr_accessor :invitation_token
  before_create :create_invitation_digest
    before_save { self.email = email.downcase }
    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
    has_secure_password
    def MUser.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
      end
      def MUser.new_token
        SecureRandom.urlsafe_base64
      end

      def downcase_email
        self.email = email.downcase
      end

      def create_invitation_digest
        self.invitation_token  = MUser.new_token
      end

      
end
