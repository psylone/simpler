class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def show
    render plain: params['id']
  end

  def create

  end

  def render_plain
    headers['Content-Type'] = 'text/plain'
    render plain: "Plain text response"
  end

end
