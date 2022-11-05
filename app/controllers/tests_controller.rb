class TestsController < Simpler::Controller

  def index
    @tests = Test.all
    render inline: '<h1><%= Time.now %></h1'
    status 202
    headers['X-Test'] = 'test'
  end

  def create; end
end
