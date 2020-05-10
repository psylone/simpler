Simpler.application.routes do
  get '/tests', 'tests#index'
  post '/tests', 'tests#create'
  get '/plain', 'tests#plain_text'
  get '/hyper', 'tests#hyper_text'
end
