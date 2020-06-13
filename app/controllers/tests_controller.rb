class TestsController < Simpler::Controller

  def index
  	render plain: 'Hello Ruslan'
  	status 201
    # @time = Time.now
  end

  def create

  end

end
