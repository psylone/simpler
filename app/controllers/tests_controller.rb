class TestsController < Simpler::Controller

  def index
    # render 'tests/list'

    # render plain: "Plain text"

    # @time = Time.now
    # render inline: "<p>Time: <%= @time %></p>"

    # render html: "<p>It's <strong>STRONG</strong></p>"

    @test = Test.first
    render json: @test

    # @test = Test.first
    # render xml: @test
  end

  def create
  end

end
