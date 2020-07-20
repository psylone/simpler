class TestsController < Simpler::Controller

  def index
    status 201
    render  plain: 'tests'
  end

  def create

  end

end
