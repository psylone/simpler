class TestsController < Simpler::Controller
  def index
    status 201
    headers['Testing'] = 'The headers'
    @time = Time.now
    render plain: 'Hello'
  end

  def create

  end

  def show
    @id = params['id']
  end
end
