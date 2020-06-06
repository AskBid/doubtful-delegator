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

	get '/users/:slug/edit' do
		redirect '/login' if !logged_in?
		@epoch = current_epoch
		@user = User.find_by_slug(params[:slug])
		if session[:user_id] == @user.id
			actual_delegations = @user.delegations.select do |d| 
				d.pool_epoch.epoch == @epoch && d.kind != 'wished'
			end

			wished_delegations = @user.delegations.select do |d| 
				d.pool_epoch.epoch == @epoch && d.kind == 'wished'
			end

			@actual_pools = actual_delegations.map {|d| d.pool_epoch.pool.id}
			@wished_pools = wished_delegations.map {|d| d.pool_epoch.pool.id}

			@pool_epochs = PoolEpoch.where('epoch = ?', @epoch)

			@pools = Pool.all

			erb :'users/edit'
		else
			flash[:message] = "You cannot edit a User that isn't yours."
			user = User.find(session[:user_id])
			redirect "/users/#{user.slug}/edit"
		end
	end

	get '/users/:slug' do
		@epoch = current_epoch
		@user = User.find_by_slug(params[:slug])

		@actual_delegations = @user.delegations.select do |d| 
			d.pool_epoch.epoch == @epoch && d.kind != 'wished'
		end

		@wished_delegations = @user.delegations.select do |d| 
			d.pool_epoch.epoch == @epoch && d.kind == 'wished'
		end

		erb :'users/show'
	end

	patch '/users/:slug' do
		# raise "#{params}"
		@epoch = current_epoch
		@user = current_user
		delegations_to_destroy = @user.delegations.select{|d| d.pool_epoch.epoch == @epoch}
		ids_to_destroy = delegations_to_destroy.map{|d| d.id }
		Delegation.destroy(ids_to_destroy)
		# "delegated_pools"=>{"1"=>"delegated", "2"=>"wished", "3"=>"delegated"}
		@delegations = params[:delegated_pools].map { |pool_id, d_kind|
				pool = Pool.find(pool_id.to_i)
				pool_epoch = pool.pool_epochs.where('epoch = ?', @epoch).first
		
				@user.pool_epochs.push(pool_epoch)
				delegation = @user.delegations.where('pool_epoch_id = ?', pool_epoch.id).first
				
				delegation.kind = d_kind
				delegation
		}

		erb :'delegations/edit'
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
			# binding.pry
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