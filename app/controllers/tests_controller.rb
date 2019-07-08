class TestsController < Simpler::Controller

  def index
    @time = Time.now
    set_headers['Content-Type'] = 'text/plain'##
    render plain: "Plain text response"##
  end

  def create
    set_status 201##
  end

  def show##
    @id = params[:id]
  end##
end
