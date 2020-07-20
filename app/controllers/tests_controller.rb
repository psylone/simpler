class TestsController < Simpler::Controller

  def index
    status 201
    headers['Content-Type'] = 'text/plain'
    render  plain: 'tests'
  end

  def create

  end

end
