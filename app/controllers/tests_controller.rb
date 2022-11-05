class TestsController < Simpler::Controller

  def index
    @tests = Test.all
    render inline: '<h1><%= Time.now %></h1'
    status 202
  end

  def create; end
end
