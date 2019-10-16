class TestsController < Simpler::Controller

  def index
    render plain: "olololo", status: 201, headers: { 'Content-Type' => 'text/plain' }
  end

  def create

  end

end
