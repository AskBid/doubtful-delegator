class DelegationsController < ApplicationController

  # GET: /delegations
  get "/delegations" do
    erb :"/delegations/index.html"
  end

  # GET: /delegations/new
  get "/delegations/new" do
    erb :"/delegations/new.html"
  end

  # POST: /delegations
  post "/delegations" do
    redirect "/delegations"
  end

  # GET: /delegations/5
  get "/delegations/:id" do
    erb :"/delegations/show.html"
  end

  # GET: /delegations/5/edit
  get "/delegations/:id/edit" do
    erb :"/delegations/edit.html"
  end

  # PATCH: /delegations/5
  patch "/delegations/:id" do
    redirect "/delegations/:id"
  end

  # DELETE: /delegations/5/delete
  delete "/delegations/:id/delete" do
    redirect "/delegations"
  end
end
