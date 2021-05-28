module RMXPExtractor
  require "rmxp_extractor/data_export"
  require "rmxp_extractor/data_import"
  require "rmxp_extractor/script_handler"
  require "rmxp_extractor/version"

  def self.usage
    STDERR.puts "usage: rmxp_extractor import|export|scripts"
    exit 1
  end

  def self.process(type)
    RMXPExtractor.usage if type.length < 1

    if type[0] == "import"
      RMXPExtractor.import
    elsif type[0] == "export"
      RMXPExtractor.export
    elsif type[0] == "scripts"
      if type[3] == "x"
        RMXPExtractor.rpgscript(type[2], type[1], true)
      elsif type.length < 3 || type.length > 4
        STDERR.puts "usage: rmxp_extractor scripts scripts_dir game_dir [x]"
        exit 1
      elsif type[3] == nil
        RMXPExtractor.rpgscript(type[2], type[1], false)
      end
    else
      RMXPExtractor.usage
    end
  end
end
