class TestsController < Simpler::Controller

  def index
    @time = Time.now

    render plain: 'Plain text response'
    status 200
  end

  def create
    render plain 'Test successfully created'
    status 201
  end

end
