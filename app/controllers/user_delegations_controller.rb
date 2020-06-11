class UserDelegationsController < ApplicationController
  
  get '/user/:slug/delegations/edit' do
    redirect '/login' if !logged_in?
    @epoch = current_epoch
    @user = User.find_by_slug(params[:slug])

    if authorized_to_edit?(@user)

      @d_pool = Pool.joins(pool_epochs: [delegations: :user])
        .where('epoch = ? AND kind = ?', @epoch, 'delegated')
        .where('username = ?', @user.username)
        .ids

      @w_pool = Pool.joins(pool_epochs: [delegations: :user])
        .where('epoch = ? AND kind = ?', @epoch, 'wished')
        .where('username = ?', @user.username)
        .ids

      @pool_epochs = PoolEpoch.where('epoch = ?', @epoch)

      @pools = Pool.all

      erb :'delegations/new'
    else
      flash[:message] = "You cannot edit a User that isn't yours."
      user = current_user
      redirect "/user/#{user.slug}/delegations/edit"
    end
  end

  post '/user/:slug/delegations' do
    @epoch = current_epoch
    @user = User.find_by_slug(params[:slug])

    d_pool_ids = params[:delegated_pools].map{|s| s.to_i}
    w_pool_ids = params[:wished_pools].map{|s| s.to_i}

    current_d_pools_ids = 
      Pool.joins(pool_epochs: [delegations: :user])
      .where('epoch = ? AND kind = ?', @epoch, 'delegated')
      .where('users.id = ?', @user.id)
      .ids

    current_w_pools_ids = 
      Pool.joins(pool_epochs: [delegations: :user])
      .where('epoch = ? AND kind = ?', @epoch, 'wished')
      .where('users.id = ?', @user.id)
      .ids

    delegations_to_destroy = @user.delegations.select{|d| d.pool_epoch.epoch == @epoch}
    ids_to_destroy = delegations_to_destroy.map{|d| d.id }

    binding.pry

    Delegation.destroy(current_d_pools_ids - d_pool_ids)
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

  patch '/user/:slug/delegations' do
    @epoch = current_epoch
    @user = User.find_by_slug(params[:slug])

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
end
