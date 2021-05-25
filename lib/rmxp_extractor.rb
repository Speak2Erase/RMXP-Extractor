module RMXPExtractor
  require "rmxp_extractor/data_export"
  require "rmxp_extractor/data_import"
  require "rmxp_extractor/version"

  def self.usage
    STDERR.puts "usage: data-extractor.rb import|export"
    exit 1
  end

  def self.process(type)
    RMXPExtractor.usage if type.length < 1

    if type[0] == "import"
      RMXPExtractor.import
    elsif type[0] == "export"
      RMXPExtractor.export
    else
      RMXPExtractor.usage
    end
  end
end
