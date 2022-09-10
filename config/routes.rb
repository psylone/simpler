# frozen_string_literal: true

Simpler.application.routes do
  get '/tests', 'tests#index'
  get '/tests/no_content', 'tests#no_content'
  get '/tests/plain_text', 'tests#plain_text'
  get '/tests/:id', 'tests#show'
  post '/tests', 'tests#create'
end
