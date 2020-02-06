Simpler.application.routes do
  get '/tests/:id', 'tests#show'
  get '/tests', 'tests#index'
  post '/tests', 'tests#create'
end
