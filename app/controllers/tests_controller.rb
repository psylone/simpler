class TestsController < Simpler::Controller

  def index
    @time = Time.now

    set_header('Content-Length', '34')
  end

  def create

  end

  def show
    render plain: params, status: 201
  end
end
