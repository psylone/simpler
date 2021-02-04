Simpler.application.routes do
  get     '/tests',          'tests#index'
  post    '/tests',          'tests#create'
  get     '/tests/new',      'tests#new'
  get     '/tests/:id',      'tests#show'
  get     '/tests/:id/edit', 'tests#edit'
  patch   '/tests/:id',      'tests#update'
  delete  '/tests/:id',      'tests#destroy'
end
