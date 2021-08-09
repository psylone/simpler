Simpler.application.routes do
  get '/tests/header', 'tests#header'
  get '/tests/text', 'tests#text'
  get '/tests/:id', 'tests#show'
  get '/tests', 'tests#index'
  post '/tests', 'tests#create'
end
