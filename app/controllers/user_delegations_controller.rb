class UserDelegationsController < ApplicationController
  
  get '/user/:slug/delegations/edit' do
    redirect '/login' if !logged_in?
    @epoch = current_epoch
    @user = User.find_by_slug(params[:slug])

    if authorized_to_edit?(@user)

      @d_pool_ids = Pool.joins(pool_epochs: [delegations: :user])
        .where('epoch = ? AND kind = ?', @epoch, 'delegated')
        .where('username = ?', @user.username)
        .ids

      @w_pool_ids = Pool.joins(pool_epochs: [delegations: :user])
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

    d_pool_ids.each { |p_id| 
      Delegation.create(
        user_id: @user.id, 
        pool_epoch_id: PoolEpoch.where('pool_id = ? AND epoch = ?', p_id, @epoch).ids.first, 
        kind: 'delegated')
    }
    w_pool_ids.each { |p_id| 
      Delegation.create(
        user_id: @user.id, 
        pool_epoch_id: PoolEpoch.where('pool_id = ? AND epoch = ?', p_id, @epoch).ids.first, 
        kind: 'wished')
    }

    @d_delegations = @user.delegations.joins(:pool_epoch)
      .where('kind = ? AND epoch = ?', 'delegated', @epoch)
    @w_delegations = @user.delegations.joins(:pool_epoch)
      .where('kind = ? AND epoch = ?', 'wished', @epoch)

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
