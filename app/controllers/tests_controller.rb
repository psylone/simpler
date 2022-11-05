class TestsController < Simpler::Controller

  def index
    @tests = Test.all
    render inline: '<h1><%= Time.now %></h1'
  end

  def create; end
end
