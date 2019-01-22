Simpler.application.routes do
  get '/tests', 'tests#index'
  post '/tests', 'tests#create'
  get '/tests/:id', 'tests#show'
  get '/tests/:id/questions/:id', 'tests#list' 
end
