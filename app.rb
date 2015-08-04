require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection(
  :adapter => 'postgresql',
  :database => 'auth_example'
)

def does_user_exist?(username)
  user = UsersModel.find_by(:name => username.to_s)
  if user
    return true
  else
    return false
  end
end


# Registration / login
get '/' do
  erb :account_form
end

# Registration action
post '/register' do
  puts '---------------'
  puts params
  puts '---------------'
  @message = ''

  if does_user_exist?(params[:name]) == true
    @message = 'Username already exists'
    return erb :login_notice
  end

  password_salt = BCrypt::Engine.generate_salt # salt is like a KEY
  password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)

  newbie = UsersModel.new
  newbie.name = params[:name]
  newbie.password_hash = password_hash
  newbie.password_salt = password_salt
  newbie.save

  @message = 'You have sucessfully registered!'

  erb :login_notice

end

# login action
post '/login' do
  puts '---------------'
  puts params
  puts '---------------'

  @message = ''
  if does_user_exist?(params[:name]) == false
    @message = 'Sorry... but that username does not exist.'
    return erb :login_notice
  end

  # find and get our user
  user = UsersModel.where(:name => params[:name]).first!

  # does the password match?
  pwd = params[:password]
  if user.password_hash == BCrypt::Engine.hash_secret(pwd, user.password_salt)
    @message = 'You have been logged in successfully'
    return erb :login_notice
  else
    @message = 'Sorry but your password does not match.'
    return erb :login_notice
  end

end
