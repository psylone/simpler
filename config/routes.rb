Simpler.application.routes do
  get '/tests', 'tests#index'
  post '/tests/:title/:level', 'tests#create'
  get '/tests/plaintest', 'tests#plaintest'
  get '/tests/:id', 'tests#show'
end
