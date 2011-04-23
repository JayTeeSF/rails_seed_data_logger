module QueryLogger
  extend self

  def on
    raise RuntimeError, "this code is horrible, find another way!"
    unless defined?(QUERY_LOG)
      @query_logger_logging_on = false
      return
    end

    # on...
    # special thx to: 
    # stackoverflow.com/questions/1629351/log-every-sql-query-to-database-in-rails
    ActiveRecord::Base.connection.class_eval do
      alias :original_exec :execute
      def execute(sql, *name)
        # puts "QL: #{QUERY_LOG}; sql: #{sql.inspect}; name: #{name.inspect}"
        # try to log sql command but ignore any errors that occur in this block
        # we log before executing, in case the execution raises an error
        begin
          TimestampedBufferedFileLogger.new(QUERY_LOG).log(sql + "; name: #{name.inspect}")
        rescue Exception => e
          ;
        end
        # execute original statement
        original_exec(sql, *name)
      end
    end

    @query_logger_logging_on = true
  end

  def off
    return unless on == @query_logger_logging_on
    # off...
    # special thx to: 
    # stackoverflow.com/questions/1629351/log-every-sql-query-to-database-in-rails
    ActiveRecord::Base.connection.class_eval do
      alias :execute :original_exec
      # alias :construct_finder_sql :original_construct_finder_sql
    end

    @query_logger_logging_on = false
  end
end
