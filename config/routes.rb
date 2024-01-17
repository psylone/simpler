Simpler.application.routes do
  get '/tests/:id', 'tests#show'
  get '/plain', 'tests#render_plain'
  get '/tests', 'tests#index'
  post '/tests', 'tests#create'
end
