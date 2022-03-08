Simpler.application.routes do
  get '/tests', 'tests#index'
  get '/test/:id', 'tests#show'
  post '/tests', 'tests#create'
end
