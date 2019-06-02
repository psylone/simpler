Simpler.application.routes do
  get '/tests/header', 'tests#header'
  get '/tests/text', 'tests#text'
  get '/tests', 'tests#index'
  post '/tests', 'tests#create'
end
