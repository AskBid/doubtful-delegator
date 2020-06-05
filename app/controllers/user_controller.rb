class UserController < ApplicationController
	use Rack::Flash

	get '/signup' do
		redirect("/users/#{current_user.slug}") if logged_in?
		erb :'users/signup'	
	end

	post '/signup' do
		# raise "#{params}"
		if User.find_by(username: 'sergio')
			flash[:message] = "The username already exist"
			redirect '/signup'
		end
		user = User.new(params) if 
		if user.save
			session[:user_id] = user.id
			redirect "/users/#{user.slug}"
		else
			redirect '/signup'
		end
	end

	get '/users/:slug' do
		@user = User.find_by_slug(params[:slug])
		@epochs = @user.pool_epochs.where("epoch >= ?", 5)

		erb :'users/show'
	end


	post '/signup' do
		user = User.new(params)
		# binding.pry
		if user.save 
			# binding.pry
			session[:user_id] = user.id
			redirect('/tweets')
		else
			redirect('/signup')
		end
	end

	get '/login' do
		# binding.pry
		if !logged_in?
			erb :'users/login'
		else
			redirect('/tweets')
		end
	end

	post '/login' do
		@user = User.find_by(username: params[:username])
		if @user && @user.authenticate(params[:password])
			session[:user_id] = @user.id
			# binding.pry
			redirect :'/tweets'
		else
			# binding.pry
			redirect :'/signup'
		end
	end

	get '/logout' do
		session.destroy
		# binding.pry
		redirect :'/login'
	end

	get "/users/:slug" do
		@user = User.find_by_slug(params[:slug])
		@tweets = @user.tweets
    erb :'users/show'
	end


end