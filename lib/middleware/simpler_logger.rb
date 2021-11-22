require 'logger'

  class SimplerLogger
    
    def initialize(app, **options)
      @app = app
      @logger = Logger.new(options[:logdev] || STDOUT)
    end

    # def initialize(app)
    #   @app = app
    #   @logger = Logger.new(Simpler.root.join('log/app.log'))
    # end

    def call(env)
      status, headers, body = @app.call(env)
      @logger.info(create_log(env, status, headers))
      [status, headers, body]
    end

    private

    def create_log(env, status, headers)
      {
        Request: "#{env['REQUEST_METHOD']} #{env['REQUEST_PATH']}",
        Handler: "#{env['simpler.controller'].class}##{env['simpler.action']}",
        Parameters: env['simpler.params'],
        Response: "#{status} [#{headers['Content-Type']}] #{env['simpler.template_path_view']}"
      }
    end
  end


  # def initialize(app, log_path)
    #   @app = app
    #   @logger = Logger.new(Simpler.root.join(log_path))
    # end



    # def initialize(app)
    #   @app = app
    #   @logger = Logger.new(File.expand_path('../../log/app.log', __dir__) || STDOUT)
    # end

