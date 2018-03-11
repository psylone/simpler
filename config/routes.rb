Simpler.application.routes do
  get '/tests', 'tests#list'
  get '/tests', 'tests#index'
  post '/tests', 'tests#create'
end
