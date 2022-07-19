module RMXPExtractor
  def self.export(format)
    STDERR.puts "No Data Directory!" unless Dir.exists? "./Data"
    exit 1 unless Dir.exists? "./Data"

    require "json"
    # require "toml-rb"
    require "yaml"
    require "amazing_print"
    require "ruby-progressbar"
    require "fileutils"
    require "pathname"
    require "readline"
    require_relative "classnames"
    require_relative "script_handler"

    window_size = 120
    progress_format = "%a /%e |%B| %p%% %c/%C %r files/sec %t, currently processing: "
    progress = ProgressBar.create(
      format: progress_format,
      starting_at: 0,
      total: nil,
      output: $stderr,
      length: window_size,
      title: "exported",
      remainder_mark: "\e[0;30m█\e[0m",
      progress_mark: "█",
      unknown_progress_animation_steps: ["==>", ">==", "=>="],
    )
    Dir.mkdir "./Data_#{format.upcase}" unless Dir.exists? "./Data_#{format.upcase}"
    paths = Pathname.glob(("./Data/" + ("*" + ".rxdata")))
    count = paths.size
    progress.total = count
    paths.each_with_index do |path, i|
      content = Hash.new

      name = path.basename(".rxdata")
      rxdata = Marshal.load(path.read(mode: "rb"))
      progress.format = progress_format + name.to_s
      case name.to_s
      when "xScripts", "Scripts"
        RMXPExtractor.rpgscript("./", "./Scripts", "#{name.to_s}.rxdata", true)
        content["version"] = VERSION
      else
        content["data"] = rxdata.rmxp_serialize
        content["version"] = VERSION
      end

      file = File.open("./Data_#{format.upcase}/" + name.sub_ext(".#{format}").to_s, "wb")
      file.puts case format
                when "yaml"
                  content.to_yaml
                when "json"
                  JSON.pretty_generate(content)
                when "toml"
                  TomlRB.dump(content)
                when "rb"
                  content.ai(index: false, indent: 2, plain: true)
                end

      progress.increment
    end
  end
end
