class TestsController < Simpler::Controller

  def index
    @time = Time.now
    case params['format']
    when 'text'
      set_header('Content-Type', 'text/plain')
      render plain: "Plain text response. Now is #{Time.now}"
    else
      # render 'tests/list'
    end

    set_status(params['status']) if params['status']
  end

  def show
    set_header('Content-Type', 'text/plain')
    render plain: "Showing test #{params['id']}. Now is #{Time.now}"
  end

  def create

  end
end
