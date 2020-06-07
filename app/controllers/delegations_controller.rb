class DelegationsController < ApplicationController
  use Rack::Flash

  get '/delegations/users/:slug/edit' do
    redirect '/login' if !logged_in?
    @epoch = current_epoch
    @user = User.find_by_slug(params[:slug])
    if authorized_to_edit?(@user)
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

      erb :'delegations/new'
    else
      flash[:message] = "You cannot edit a User that isn't yours."
      user = current_user
      redirect "/delegations/users/#{user.slug}/edit"
    end
  end

  post '/delegations/users/:slug' do
    @epoch = current_epoch
    @user = User.find_by_slug(params[:slug])
    delegations_to_destroy = @user.delegations.select{|d| d.pool_epoch.epoch == @epoch}
    ids_to_destroy = delegations_to_destroy.map{|d| d.id }
    Delegation.destroy(ids_to_destroy)
    # "delegated_pools"=>{"1"=>"delegated", "2"=>"wished", "3"=>"delegated"}
    delegations = params[:delegated_pools].map{|pool_id, d_kind|
        pool = Pool.find(pool_id.to_i)
        pool_epoch = pool.pool_epochs.where('epoch = ?', @epoch).first
    
        @user.pool_epochs.push(pool_epoch)
        delegation = @user.delegations.where('pool_epoch_id = ?', pool_epoch.id).first
        delegation.kind = d_kind
        delegation.save
        delegation
    }
    @actual_delegations = delegations.select {|d| d.kind != 'wished'}
    @wished_delegations = delegations.select {|d| d.kind == 'wished'}

    erb :'delegations/edit'
  end

  patch '/delegations/users/:slug' do
    @epoch = current_epoch
    @user = User.find_by_slug(params[:slug])
    binding.pry
    normalise_delegations(params[:delegations_actual]).each{|delegation_id, _params|
      Delegation.find(delegation_id.to_i).update(_params)
    } if params[:delegations_actual]

    normalise_delegations(params[:delegations_wished]).each{|delegation_id, _params|
      Delegation.find(delegation_id.to_i).update(_params)
    } if params[:delegations_wished]

    if params[:delegations_actual]
      @actual_delegations = Delegation.find(params[:delegations_actual].keys)
    end
    if params[:delegations_wished]
      @wished_delegations = Delegation.find(params[:delegations_wished].keys)
    end

    erb :'users/show'
  end

  delete "/delegations/users/:slug/delete" do
  end
end
