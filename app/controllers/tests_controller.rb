class TestsController < Simpler::Controller

  def index
  	render plain: 'Hello Ruslan'
  	set_headers 'text/plain'
    # @time = Time.now
  end

  def create
  	set_status 201
  end

end
