Simpler.application.routes do
  get '/tests', 'tests#index'
  get '/tests/:id', 'tests#show'
  post '/tests', 'tests#create'
  get '/user/:login/payments/:month/year/:year', 'users#show'
  get '/test/users/name/:name/age/:age', 'users#index'
end
