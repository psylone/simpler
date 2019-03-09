class CustomHeaders

  def initialize(response)
    @response = response
  end

  def []=(header, value)
    @response[header] = value
  end

end
