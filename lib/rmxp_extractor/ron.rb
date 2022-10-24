# This file handles rusty object notation.
require_relative "classnames"

$indent = 0

class Object
  def rmxp_serialize
    $indent += 2
    str = "#{self.class.name.split("::").last}(\n"
    self.instance_variables.each { |var| str += "#{"  " * $indent}#{var.to_s.delete("@")}: #{self.instance_variable_get(var).rmxp_serialize},\n" }
    $indent -= 2
    str += "#{"  " * $indent})"
    str
  end
end

class Table
  def rmxp_serialize
    str = "Array(\n"
    $indent += 2
    str += "#{"  " * $indent}v: 1,\n"
    str += "#{"  " * $indent}dim: ("
    str += case @num_of_dimensions
      when 1
        "#{@xsize}"
      when 2
        "#{@ysize}, #{@xsize}"
      when 3
        "#{@zsize}, #{@ysize}, #{@xsize}"
      end
    str += "),\n"
    str += "#{"  " * $indent}data: [\n"
    $indent += 2
    case @num_of_dimensions
    when 1
      str += "#{"  " * $indent}"
      @elements.each_with_index do |e, index|
        str += "#{e}, "
        str += "\n#{"  " * $indent}" if (index + 1) % 8 == 0
      end
      str += "\n"
    when 2
      @elements.each do |y|
        str += "  " * $indent
        y.each { |e| str += "#{e}, " }
        str += "\n"
      end
    when 3
      @elements.each do |z|
        z.each do |y|
          str += "  " * $indent
          y.each { |e| str += "#{e}, " }
          str += "\n"
        end
        str += "\n"
      end
    end
    $indent -= 2
    str += "#{"  " * $indent}]\n"
    $indent -= 2
    str += "#{"  " * $indent})"
    str
  end
end

class Hash
  def rmxp_serialize
    str = "{\n"
    $indent += 2
    self.each { |key, value| str += "#{"  " * $indent}#{key.rmxp_serialize}: #{value.rmxp_serialize},\n" }
    $indent -= 2
    str += "#{"  " * $indent}}"
    str
  end
end

# BAD BAD
class NilClass
  def rmxp_serialize
    "None"
  end
end

class String
  def rmxp_serialize
    self.inspect
  end
end

class Array
  def rmxp_serialize
    unless self.empty?
      str = "[\n"
      $indent += 2
      self.each { |e| next unless e; str += "#{"  " * $indent}#{e.rmxp_serialize},\n" }
      $indent -= 2
      str += "#{"  " * $indent}]"
    else
      str = "[]"
    end
    str
  end
end

module RPG
  class EventCommand
    def rmxp_serialize
      str = "EventCommand(\n"
      $indent += 2
      str += "#{"  " * $indent}indent: #{@indent},\n"
      str += "#{"  " * $indent}code: #{@code},\n"
      str += "#{"  " * $indent}parameters: ["
      if @parameters.empty?
        str += "],\n"
      else
        $indent += 2
        @parameters.each do |param|
          str += "\n#{"  " * $indent}#{param.class.name.split("::").last}(#{param.rmxp_serialize}),"
        end
        $indent -= 2
        str += "\n#{"  " * $indent}],\n"
      end
      $indent -= 2
      str += "#{"  " * $indent})"
      str
    end
  end

  class MoveCommand
    def rmxp_serialize
      str = "MoveCommand(\n"
      $indent += 2
      str += "#{"  " * $indent}code: #{@code},\n"
      str += "#{"  " * $indent}parameters: ["
      $indent += 2
      @parameters.each do |param|
        str += "\n#{"  " * $indent}#{param.class.name.split("::").last}(#{param.rmxp_serialize}),"
      end
      $indent -= 2
      str += "\n#{"  " * $indent}],\n"
      $indent -= 2
      str += "#{"  " * $indent})"
      str
    end
  end
end
