module RMXPExtractor
  require "rmxp_extractor/data_export"
  require "rmxp_extractor/data_import"
  require "rmxp_extractor/script_handler"
  require "rmxp_extractor/version"

  FORMATS = ["json", "yaml", "rb", "ron"]

  def self.usage
    STDERR.puts "usage: rmxp_extractor < -v/--version > import/export <type = json> | scripts"
    exit 1
  end

  def self.process(type)
    RMXPExtractor.usage if type.length < 1

    case type[0]
    when "-v", "--version"
      puts VERSION
    when "import"
      check_format(type[1])
      import(type[1])
    when "export"
      check_format(type[1])
      export(type[1])
    when "scripts"
      if type.length < 4 || type.length > 5
        STDERR.puts "usage: rmxp_extractor scripts game_dir scripts_dir scripts_name  [x]"
        exit 1
      else
        puts type.to_s
        RMXPExtractor.rpgscript(type[1], type[2], type[3], type[4] == "x")
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
