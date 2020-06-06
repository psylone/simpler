# frozen_string_literal: true

Simpler.application.routes do
  get '/', 'tests#index'
  get '/tests', 'tests#index'
  get '/tests/:id', 'tests#show'
  post '/tests', 'tests#create'
end
