class TestsController < Simpler::Controller

  def index
    @time = Time.now
    status(201)
  end

  def create; end

  def status(code)
    @response.status = code
  end

end
