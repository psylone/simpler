# frozen_string_literal: true

class JsonRender
  attr_reader :header
  def initialize(format)
    @format = format
    @header = 'text/json'
  end
  end
