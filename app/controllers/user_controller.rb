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
		@delegations = @user.delegations.map {|d| d.pool_epoch.epoch == current_epoch}
		
		erb :'users/show'
	end

	get '/login' do
		# binding.pry
		if !logged_in?
			erb :'users/login'
		else
			user = User.find(session[:user_id])
			redirect("/users/#{user.slug}")
		end
	end

	post '/login' do
		@user = User.find_by(username: params[:username])

		if @user && @user.authenticate(params[:password])
			session[:user_id] = @user.id
			# binding.pry
			redirect :"/users/#{@user.slug}"
		else
			flash[:message] = "You tried to Log In with a User that doesn't exist"
			redirect :'/signup'
		end
	end

	get '/logout' do
		session.destroy
		# binding.pry
		redirect :'/login'
	end


end