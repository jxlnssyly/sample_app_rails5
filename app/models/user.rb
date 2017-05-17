class User < ApplicationRecord
	before_save { self.email = email.downcase }
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	validates :password,presence: true, length: { maximum: 6 }
=begin
在模型中调用这个方法后，会自动添加如下功能：
在数据库中的 password_digest 列存储安全的密码哈希值；
获得一对虚拟属性，[18]password 和 password_confirmation，而且创建用户对象时会执行存在性验证和匹配验证；
获得 authenticate 方法，如果密码正确，返回对应的用户对象，否则返回 false。
=end
	has_secure_password


	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
		BCrypt::Password.create(string,cost: cost)
	end

end
