Simpler.application.routes do
  get '/tests', 'tests#index'
  post '/tests', 'tests#create'
end
