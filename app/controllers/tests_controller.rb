class TestsController < Simpler::Controller

  def index
    @time = Time.now
    status 201
  end

  def show
    @id = params[:id]
    puts @id.inspect
    puts params.inspect
  end

  def create; end
end
