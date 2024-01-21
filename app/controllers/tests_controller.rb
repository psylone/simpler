class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def create; end

  def show
    status(201)
    @test = Test.first(id: params['id'])
  end

  def render_plain
    headers['Content-Type'] = 'text/plain'
    render plain: "Plain text response"
  end

end
