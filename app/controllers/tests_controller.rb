class TestsController < Simpler::Controller

  def index
  	render plain: 'Hello Ruslan'
  	set_status 201
  	set_headers 'text/plain'
    # @time = Time.now
  end

  def create

  end

end
