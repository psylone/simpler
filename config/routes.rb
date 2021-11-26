Simpler.application.routes do
  get '/tests/:id', 'tests#show'
  get '/tests', 'tests#index'
  post '/tests', 'tests#create'
  get '/not_found', 'errors#not_found'
end
