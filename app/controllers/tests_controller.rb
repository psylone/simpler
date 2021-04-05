require 'pry'
class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render plain:'Hello'
    status 201
    headers['Content-Type'] = 'text/plain'
  end

  def create

  end

  def show
  	binding.pry
  	params
  	render plain:'Hello from show'
  end

end
