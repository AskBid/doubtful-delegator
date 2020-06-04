class PoolEpochsController < ApplicationController

  # GET: /pool_epochs
  get "/pool_epochs" do
    erb :"/pool_epochs/index.html"
  end

  # GET: /pool_epochs/new
  get "/pool_epochs/new" do
    erb :"/pool_epochs/new.html"
  end

  # POST: /pool_epochs
  post "/pool_epochs" do
    redirect "/pool_epochs"
  end

  # GET: /pool_epochs/5
  get "/pool_epochs/:id" do
    erb :"/pool_epochs/show.html"
  end

  # GET: /pool_epochs/5/edit
  get "/pool_epochs/:id/edit" do
    erb :"/pool_epochs/edit.html"
  end

  # PATCH: /pool_epochs/5
  patch "/pool_epochs/:id" do
    redirect "/pool_epochs/:id"
  end

  # DELETE: /pool_epochs/5/delete
  delete "/pool_epochs/:id/delete" do
    redirect "/pool_epochs"
  end
end
