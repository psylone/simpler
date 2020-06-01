require_relative 'config/environment'
# run Simpler::Application.instance можно и так написать но не пишем поскольку не хотим показывать rack внутренее устройство классов и методов и тп
run Simpler.application
