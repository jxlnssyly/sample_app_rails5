require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
  	@user = User.new(name: "Example User",email: 	"user@example.com",password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
  	assert @user.valid?
  end

  test "name should be present" do
  	@user.name = ""
  	assert_not @user.valid? # 断言里面的代码返回false，说明测试成功
  end

  # 邮箱能不能为空
  test "email should be present" do
  	@user.email = " "
  	assert_not @user.valid?
  end

  # 名字最大长度为50位的验证
  test "name should not be too long" do
  	@user.name = "a" * 51
  	assert_not @user.valid?
  end

  # 邮箱最大长度为255位的验证
  test "email should not be too long" do
  	@user.email = "a" * 244 + "@example.com"
  	assert_not @user.valid?
  end

  # 邮箱有没有对格式进行验证
  test "email validation should accept valid addresses" do
  	valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]

    valid_addresses.each do |valid_address|

    	@user.email = valid_address
    	assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  # 邮箱是不是唯一的
  test "email addresses should be unique" do
  	duplicate_user = @user.dup
  	duplicate_user.email = @user.email.upcase
  	@user.save
  	assert_not duplicate_user.valid?
  end

  # 邮箱有没有转成小写存入数据库
  test "email addresses should be saved as lower-case" do
  	mixed_case_email = "Foo@ExaMPle.com"
  	@user.email = mixed_case_email
  	@user.save
  	assert_equal mixed_case_email.downcase, @user.reload.email
  end

  # 密码不能为空
  test "password should be present (nonblank)" do
  	@user.password = @user.password_confirmation = " " * 6
  	assert_not @user.valid?
  end

end
