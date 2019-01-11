class TestsController < Simpler::Controller

  def index
    @time = Time.now

    render plain: "Plain text response!!!"
    headers['Content-Type'] = 'text/plain'
  end

  def create

  end

end
