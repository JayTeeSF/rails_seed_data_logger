class TimestampedBufferedFileLogger < ActiveSupport::BufferedLogger

  def initialize(path_to_file)
    @buffer        = {}
    @auto_flushing = 1
    @guard = Mutex.new
  
    if File.exist?(path_to_file)
      @log = open(path_to_file, (File::WRONLY | File::APPEND))
    else
      FileUtils.mkdir_p(File.dirname(path_to_file))
      @log = open(path_to_file, (File::WRONLY | File::APPEND | File::CREAT))
    end
    @log.sync = true
  end

  def log(message)
    add(nil, message)
  end

  private

  def add(severity, message = nil, progname = nil, &block)
    message = message.to_s
    buffer << "%s - #{message}\n" % [Time.now.to_f.to_s]
    auto_flush
    message
  end
end