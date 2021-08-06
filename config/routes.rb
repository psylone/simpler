Simpler.application.routes do
  get '/tests', 'tests#index'
  post '/tests', 'tests#create'
  post '/tests/:id', 'tests#show'
end
