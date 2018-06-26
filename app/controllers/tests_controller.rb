class TestsController < Simpler::Controller

  def index
    #@time = Time.now
    render plain: 'Text'
    status 201
  end

  def create

  end

end
