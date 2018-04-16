class TestsController < Simpler::Controller

  def index
    # @time = Time.now
    # render html: '<h1>Plain text response</h1>'
    # status 201
    set_header 'Content-Type', 'text/plain'
  end

  def create

  end

end
