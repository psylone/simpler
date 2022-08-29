class HistoryLogger
  attr_reader :out_params

  def initialize(app)
    @app = app
    @out_params = {}
    #@logger = Logger.new(Simpler.root.join('log/app.log'))
  end

  def call(env)
    status, headers, response = @app.call(env)

    @out_params[:Request] = "#{env['REQUEST_METHOD']} #{env['REQUEST_PATH']}"
    @out_params[:Handler] = "#{env['simpler.controller'].class}##{env['simpler.action']}"
    @out_params[:Parameters] =  "#{env['simpler.controller.params']}"
    @out_params[:Response] = "#{status} [#{headers['Content-Type']}] #{env['simpler.template_path']}"

    add_log(@out_params)

    [status, headers, response]
  end

  def add_log(content)
    logfile = "log/app.log"
    File.open(logfile, 'a') do |file|
      content.each{ |k, v| file << ("#{k}: #{v}\n") }
      file << "\n"
    end
  end

end
