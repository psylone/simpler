class TestsController < Simpler::Controller

  def index
    @time = Time.now
    status 201
    headers['X-Header'] = 'true'
    render inline: "<%= @time %>"
  end

  def create

  end

  def show
    @parameters = params
  end

end
