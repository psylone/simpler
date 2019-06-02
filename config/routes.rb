Simpler.application.routes do
  get '/tests/text', 'tests#text'
  get '/tests', 'tests#index'
  post '/tests', 'tests#create'
end
