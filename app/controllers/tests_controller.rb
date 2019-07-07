class TestsController < Simpler::Controller

  def index
    render inline: "#{Time.now}"
  end

  def create

  end

end
