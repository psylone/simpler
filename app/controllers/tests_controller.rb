require 'byebug'
class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render plain: 'Just simple text'
    set_status :bad_request
    render 'tests/list'
    set_headers 'text/plain'
  end

  def create

  end

  def show
    @id = params[:id]
    byebug
  end

end
