module RMXPExtractor
  def self.export
    STDERR.puts "No Data Directory!" unless Dir.exists? "./Data"
    exit 1 unless Dir.exists? "./Data"

    require "json"
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
      title: "Exported",
      remainder_mark: "\e[0;30m█\e[0m",
      progress_mark: "█",
      unknown_progress_animation_steps: ["==>", ">==", "=>="],
    )
    Dir.mkdir "./Data_JSON" unless Dir.exists? "./Data_JSON"
    paths = Pathname.glob(("./Data/" + ("*" + ".rxdata")))
    count = paths.size
    progress.total = count
    paths.each_with_index do |path, i|
      content = Hash.new

      name = path.basename(".rxdata")
      rxdata = Marshal.load(path.read(mode: "rb"))
      #puts name.to_s
      case name.to_s
      when "xScripts"
        RMXPExtractor.rpgscript("./", "./Scripts", true)
        content[:version] = VERSION
      else
        content[:data] = rxdata.rmxp_serialize
        content[:version] = VERSION
      end

      json = File.open("./Data_JSON/" + name.sub_ext(".json").to_s, "wb")
      #puts content
      json.puts JSON.pretty_generate(content)

      progress.increment
    end
  end
end
