# QueryLogger.on if defined?(QUERY_LOG)
filenames = Dir[Rails.root.join('app', 'models', '**/*.rb').to_s]

models_from_files = filenames.map do |filename|
  File.read(filename).scan(/class ([\w\d_\-:]+)/).flatten
end.flatten!

models = models_from_files.collect do |c|
  begin
    Object.const_get(c.to_sym)
    if c.constantize.ancestors.include?(ActiveRecord::Base)
      c.constantize
    else
      nil
    end
  rescue Exception => e
    puts "caught e: #{e.message}"
    nil
  end
end.compact

IncludeLoggers.for *models
