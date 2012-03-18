class User < ActiveRecord::Base
	has_many :user_books
  has_many :libraries

	# Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

	def send_email
  	recipients  self.email
  	from        "webmaster@example.com"
  	subject     "Thank you for Registering"
  	body        :user => self
 	end

end
