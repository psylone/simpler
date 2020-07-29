class TestsController < Simpler::Controller

  def index
    status 201
    render plain: 'abc'
    @time = Time.now
    headers['A'] = 'B'
  end

  def create
    binding.pry
  end

  def show
  end

end
