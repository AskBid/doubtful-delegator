require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    # set :sessions, true
    enable :sessions
    set :session_secret, "my_application_secret"
  end

  get '/' do
		erb :welcome
  end

  helpers do

    def logged_in?
      !!current_user
    end

    def current_user
      # binding.pry
      User.find_by(id: session[:user_id])
    end

    def current_epoch
      PoolEpoch.maximum('epoch')
    end

    def authorized_to_edit?(user)
      user == current_user
    end

    def normalise_delegations(dele_params)
      if dele_params
        sum = dele_params.map{|k, v| v.values.first.to_f}.sum
        multiplier = 1/sum
        new_params = {}
        dele_params.each{ |k, v| 
          new_params[k] = {"amount"=>"#{v.values.first.to_f * multiplier}"}
        }
        new_params
      end
    end

  end

end
