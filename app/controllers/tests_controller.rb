class TestsController < Simpler::Controller

  def index
    @time = Time.now
    set_status 201
    set_headers({ 'Content-Type' => 'text/plain'})
    render plain: "Plain text response"
  end

  def create

  end

  def show

  end

end
