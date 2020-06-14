class TestsController < Simpler::Controller

  def index
  	render plain: 'Hello Ruslan'
  	set_headers 'text/plain'
    # @time = Time.now
  end

  def create
  	render plain: 'This is POST'
    set_status 201
  end

  def show
    @param = params[:id]
    # set_headers 'text/plain'
    # render plain: 'Hi MAN'
  end
end
