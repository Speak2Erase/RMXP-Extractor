module RMXPExtractor
  require "rmxp_extractor/data_export"
  require "rmxp_extractor/data_import"
  require "rmxp_extractor/script_handler"
  require "rmxp_extractor/version"

  FORMATS = ["json", "yaml", "rb"]

  def self.usage
    STDERR.puts "usage: rmxp_extractor import/export <type = json> | scripts"
    exit 1
  end

  def self.process(type)
    RMXPExtractor.usage if type.length < 1

    case type[0]
    when "import"
      check_format(type[1])
      import(type[1])
    when "export"
      check_format(type[1])
      export(type[1])
    when "scripts"
      if type.length < 4 || type.length > 5
        STDERR.puts "usage: rmxp_extractor scripts scripts_dir scripts_name game_dir [x]"
        exit 1
      else
        RMXPExtractor.rpgscript(type[3], type[4], type[5] == "x")
      end
    else
      RMXPExtractor.usage
    end
  end

  def self.check_format(format)
    format = "json" if format.nil?
    unless FORMATS.include?(format)
      warn "Allowed formats: #{FORMATS.to_s}"
      exit 1
    end
  end
end
