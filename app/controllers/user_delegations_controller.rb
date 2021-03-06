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
    redirect '/login' if !logged_in?
    @epoch = current_epoch
    @user = User.find_by_slug(params[:slug])
    redirect '/users/:slug' if !authorized_to_edit?(@user)

    current_d_pool_epoch_ids = @user.pool_epochs
      .where('kind = ? AND epoch = ?', 'delegated', @epoch).ids

    current_w_pool_epoch_ids = @user.pool_epochs
      .where('kind = ? AND epoch = ?', 'wished', @epoch).ids

    selected_d_pool_epoch_ids = 
      PoolEpoch.where(pool_id: params[:delegated_pools].map{|s| s.to_i})
        .where(epoch: @epoch)
        .ids    
    selected_w_pool_epoch_ids = 
      PoolEpoch.where(pool_id: params[:wished_pools].map{|s| s.to_i})
        .where(epoch: @epoch)
        .ids

    deselected_pool_epoch_ids = 
      (current_d_pool_epoch_ids - selected_d_pool_epoch_ids) + 
      (current_w_pool_epoch_ids - selected_w_pool_epoch_ids) 
    Delegation.where(pool_epoch_id: deselected_pool_epoch_ids).delete_all

    selected_d_pool_epoch_ids.each {|pool_epoch_id|
      Delegation.create(
        user_id: @user.id,
        pool_epoch_id: pool_epoch_id,
        kind: 'delegated')
    }
    selected_w_pool_epoch_ids.each {|pool_epoch_id|
      Delegation.create(
        user_id: @user.id,
        pool_epoch_id: pool_epoch_id,
        kind: 'wished')
    }

    @d_delegations = @user.delegations.joins(:pool_epoch)
      .where('kind = ? AND epoch = ?', 'delegated', @epoch)
    @w_delegations = @user.delegations.joins(:pool_epoch)
      .where('kind = ? AND epoch = ?', 'wished', @epoch)

    erb :'delegations/edit'
  end

  patch '/user/:slug/delegations' do
    redirect '/login' if !logged_in?
    @epoch = current_epoch
    @user = User.find_by_slug(params[:slug])
    if !authorized_to_edit?(@user)
      flash[:message] = "You cannot edit a User that isn't yours."
      redirect "/users/#{current_user.slug}" 
    end

    normalise_delegations(params[:delegations_actual]).each{|delegation_id, _params|
      Delegation.find(delegation_id.to_i).update(_params)
    } if params[:delegations_actual]

    normalise_delegations(params[:delegations_wished]).each{|delegation_id, _params|
      Delegation.find(delegation_id.to_i).update(_params)
    } if params[:delegations_wished]

    redirect :"users/#{params[:slug]}"
  end
end
