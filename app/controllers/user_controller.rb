class UserController < ApplicationController
	# use Rack::Flash

	get '/signup' do
		redirect("/users/#{current_user.slug}") if logged_in?
		erb :'users/signup'	
	end

	post '/signup' do
		user = User.new(params)
		if user.save
			session[:user_id] = user.id
			redirect "/users/#{user.slug}"
		else
			flash[:message] = user.errors.map {|k, m| m}
			binding.pry
			redirect '/signup'
		end
	end

	get '/users/:slug' do
		@epoch = current_epoch
		@user = User.find_by_slug(params[:slug])
		binding.pry
		@actual_delegations = @user.delegations.joins(:pool_epoch)
			.where('kind = ? AND epoch = ?', 'delegated', @epoch)

		@wished_delegations =  @user.delegations.joins(:pool_epoch)
			.where('kind = ? AND epoch = ?', 'wished', @epoch)

		erb :'users/show'
	end

	get '/users/:slug/edit' do
		redirect '/login' if !logged_in?
		@user = User.find_by_slug(params[:slug])
		if authorized_to_edit?(@user)
			erb :'users/edit'
		else
			flash[:message] = "You tried to edit a User that is not you"
			redirect :"/users/#{current_user.slug}/edit"
		end
	end

	patch '/users/:slug' do
		@epoch = current_epoch
		@user = User.find_by_slug(params[:slug])
		@user.update(params[:user])

		@actual_delegations = @user.delegations.joins(:pool_epoch)
			.where('kind = ? AND epoch = ?', 'delegated', @epoch)

		@wished_delegations =  @user.delegations.joins(:pool_epoch)
			.where('kind = ? AND epoch = ?', 'wished', @epoch)

		erb :'users/show'
	end

	delete '/users/:slug' do
		redirect '/login' if !logged_in?
		@user = User.find_by_slug(params[:slug])
		if authorized_to_edit?(@user)
			session.destroy
			@user.destroy
		end
		redirect '/'
	end

	get '/login' do
		if !logged_in?
			erb :'users/login'
		else
			user = current_user
			redirect("/users/#{user.slug}")
		end
	end

	post '/login' do
		@user = User.find_by(username: params[:username])

		if @user && @user.authenticate(params[:password])
			session[:user_id] = @user.id
			redirect :"/users/#{@user.slug}"
		else
			flash[:message] = "You tried to Log In with a User that doesn't exist"
			redirect :'/signup'
		end
	end

	get '/logout' do
		session.destroy
		redirect :'/login'
	end

end