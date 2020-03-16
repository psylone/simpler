# frozen_string_literal: true

Simpler.application.routes do
  get '/tests/:id/value', 'tests#index'
  post '/tests', 'tests#create'
end
