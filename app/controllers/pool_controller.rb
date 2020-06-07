class PoolController < ApplicationController
  get "/pool_epochs/:address/edit" do
    erb :"/pool_epochs/edit.html"
  end
end
