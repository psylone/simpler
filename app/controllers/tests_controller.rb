class TestsController < Simpler::Controller

  def index
    # render 'tests/list'
    @tests = Test.all
    @time = Time.now
    # render plain: "Plain text response\n"
    status(201)
    headers['Content-Type-ASD'] = 'asdasdasd'
  end

  def show
    render ijjh: "Plain text response\n"
    # @params = params
  end

  def create
    render plain: "Plain text response\n"
    status(201)
    headers['Content-Type-ASD'] = 'asdasdasd'
  end

end
