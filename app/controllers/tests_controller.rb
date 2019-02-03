class TestsController < Simpler::Controller
  def index
    @time = Time.now
    render plain: 'Привет!'
    # set_header 'Greetings', 'Hi/Aloha/Ciao'
    # render plain: "Plain text response\n", content_type: 'text/plain', status: 205
    # list
    # render plain: 'Plain text response', content_type: 'text/plain', status: 204
  end

  def list
    render html: "<h1><i>HERE WE GO </i></h1>", status: 202
  end

  def create
  end

  def show
    @id = params[:id]
  end
end
