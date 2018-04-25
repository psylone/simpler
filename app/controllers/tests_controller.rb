class TestsController < Simpler::Controller

  def index
    @time = Time.now
    status 201
    headers['X-header'] = 'true'
    render plain: "#{@time}"
  end

  def show
    @params = params
  end

  def create
  end
end
