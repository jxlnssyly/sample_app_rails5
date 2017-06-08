class User < ApplicationRecord
	attr_accessor :remember_token, :activation_token
	before_save { self.email = email.downcase }
	before_create :create_activation_digest
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	# validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false} # case_sensitive 不区分大小写

	validates :password,presence: true, length: { maximum: 6 }, allow_nil: true
=begin
在模型中调用这个方法后，会自动添加如下功能：
在数据库中的 password_digest 列存储安全的密码哈希值；
获得一对虚拟属性，[18]password 和 password_confirmation，而且创建用户对象时会执行存在性验证和匹配验证；
获得 authenticate 方法，如果密码正确，返回对应的用户对象，否则返回 false。
=end
	has_secure_password

	class << self

		def digest(string)
			cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
			BCrypt::Password.create(string,cost: cost)
		end

		#返回一个随机令牌
		def new_token
			SecureRandom.urlsafe_base64
		end
		
	end

	# 忘记用户
	def forget
		update_attribute(:remember_digest, nil)
	end


	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest,User.digest(remember_token))
	end

	def authenticated?(remember_token)
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
		
	end

	private
		# 电子邮件地址转换成小写
		def downcase_email
			self.email = email.downcase
		end

		def create_activation_digest
			self.activation_token = User.new_token
			self.activation_digest = User.digest(activation_token)
		end

end
