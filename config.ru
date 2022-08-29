require_relative 'config/environment'
require_relative 'lib/middleware/historylogger'

use HistoryLogger
run Simpler.application
