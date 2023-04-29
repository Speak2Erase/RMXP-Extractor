module RMXPExtractor
  def self.import(format)
    STDERR.puts "No Data_JSON Directory!" unless Dir.exist? "./Data_#{format.upcase}"
    exit 1 unless Dir.exist? "./Data_#{format.upcase}"

    require "oj"
    require "yaml"
    require "ruby-progressbar"
    require "fileutils"
    require "pathname"
    require "readline"
    require_relative "classnames"
    require_relative "script_handler"

    if format == "ron"
      puts "RON not supported for importing yet"
      exit 1
    end

    window_size = 120
    progress_format = "%a /%e |%B| %p%% %c/%C %r files/sec %t, currently processing: "
    progress = ProgressBar.create(
      format: progress_format,
      starting_at: 0,
      total: nil,
      output: $stderr,
      length: window_size,
      title: "imported",
      remainder_mark: "\e[0;30m█\e[0m",
      progress_mark: "█",
      unknown_progress_animation_steps: ["==>", ">==", "=>="],
    )
    Dir.mkdir "./Data" unless Dir.exist? "./Data"
    paths = Pathname.glob(("./Data_#{format.upcase}/" + ("*" + ".#{format}")))
    count = paths.size
    progress.total = count
    paths.each_with_index do |path, i|
      name = path.basename(".#{format}")
      progress.format = progress_format + name.to_s
      file_contents = path.read(mode: "rb")
      hash = case format
        when "json"
          Oj.load file_contents
        when "yaml"
          YAML.load file_contents
        when "rb"
          eval file_contents # Yes, this SHOULD work. Is it bad? Yes.
        end

      warn "\n\e[33;1mWARNING: Incompatible version format in #{name.to_s}!\e[0m\n" if hash["version"] != VERSION

      case name.to_s
      when "xScripts", "Scripts"
        RMXPExtractor.rpgscript("./", "./Scripts", "#{name.to_s}")
        progress.increment
        return
      else
        content = create_from_rmxp_serialize(hash["data"])
      end

      begin
        dump = Marshal.dump(content)

        rxdata = File.open("./Data/" + name.sub_ext(".rxdata").to_s, "wb")
        rxdata.puts dump
      rescue TypeError => e
        puts "Failed to dump file #{path}.\n"
        next
      end

      progress.increment
    end
  end
end
