class TestsController < Simpler::Controller

  def index
    status 201
    headers['Content-Type'] = 'text/plain'
    render plain: "Plain text response"
  end

  def create

  end

  def show
   @test = Test[params[:id]]
  end
end
