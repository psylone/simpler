class TestsController < Simpler::Controller

  def index
    @time = Time.now
    status 201
    headers['Some-Header'] = 'Title'
    render plain: "#{@time}"
  end

  def create
  end

  def show
    @params = params
  end
end
