require 'pry'

class TestsController < Simpler::Controller

  def index
    @time = Time.now
    status 201
  end

  def create;end

  def show
    params
    render plain:'Hello from show'
  end
end
