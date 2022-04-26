module RMXPExtractor
  def self.import
    STDERR.puts "No Data_JSON Directory!" unless Dir.exists? "./Data_JSON"
    exit 1 unless Dir.exists? "./Data_JSON"

    require "oj"
    require "ruby-progressbar"
    require "fileutils"
    require "pathname"
    require "readline"
    require_relative "classnames"
    require_relative "script_handler"

    window_size = 120
    progress = ProgressBar.create(
      format: "%a /%e |%B| %p%% %c/%C %r files/sec %t",
      starting_at: 0,
      total: nil,
      output: $stderr,
      length: window_size,
      title: "Imported",
      remainder_mark: "\e[0;30m█\e[0m",
      progress_mark: "█",
      unknown_progress_animation_steps: ["==>", ">==", "=>="],
    )
    Dir.mkdir "./Data" unless Dir.exists? "./Data"
    paths = Pathname.glob(("./Data_JSON/" + ("*" + ".json")))
    count = paths.size
    progress.total = count
    paths.each_with_index do |path, i|
      name = path.basename(".json")
      json = Oj.load path.read(mode: "rb")

      puts "\n\e[33;1mWARNING: Incompatible version format in #{name.to_s}!\e[0m\n" if json["version"] != VERSION

      case name.to_s
      when "xScripts"
        RMXPExtractor.rpgscript("./", "./Scripts")
        progress.increment
        return
      else
        content = create_from_rmxp_serialize(json["data"])
      end

      rxdata = File.open("./Data/" + name.sub_ext(".rxdata").to_s, "wb")
      rxdata.puts Marshal.dump(content)

      progress.increment
    end
  end
end
