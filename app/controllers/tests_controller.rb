class TestsController < Simpler::Controller

  def index
    # render 'tests/index'

    # render plain: "Plain text response\n"

    # @response.headers['Content-Type'] = 'text/plain'
    # render plain: "Plain text response!\n"
    # status 201


    xml = <<~XML_STR
      <note>
        <to>Tove</to>
        <from>Jani</from>
        <heading>Reminder</heading>
        <body>Don't forget me this weekend!</body>
      </note>
    XML_STR
    @response.headers['Content-Type'] = 'text/xml'
    render xml: xml
  end

  def create

  end

  def show
    puts "params:#{params}"
    @test = Test.where(id: params[:id]).first.inspect
  end

end
