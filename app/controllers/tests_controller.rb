class TestsController < Simpler::Controller

  def index
    status 201
    custom_headers['Testing'] = 'The headers'
    @time = Time.now
    render plain: 'tests/list'
  end

  def create

  end

  def show
    @id = params[':id']
  end

end
