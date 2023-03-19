def const_from_string(str)
  str.split("::").inject(Object) do |mod, class_name|
    mod.const_get(class_name)
  end
end

def create_from_rmxp_serialize(obj)
  if obj.is_a?(Hash)
    ret = {}
    # Hashes have no map method. Why? I dunno!
    obj.each do |key, value|
      if key.is_a?(String) && key.start_with?("class ")
        const = const_from_string(key.delete_prefix("class "))
        ret = const.new.from_rmxp_serialize(value)
      else
        if key.is_a?(String) && key =~ /\A[0-9]+\z/ # Key is an integer
          key = key.to_i
        end
        ret[key] = create_from_rmxp_serialize(value)
      end
    end
    return ret
  end
  if obj.is_a?(Array)
    obj.map! do |value|
      create_from_rmxp_serialize(value)
    end
  end
  ret = obj
end

class Object
  def rmxp_serialize
    hash = {}
    self.instance_variables.sort.each { |var| hash[var.to_s.delete("@")] = self.instance_variable_get(var).rmxp_serialize }
    { "class #{self.class.name}" => hash }
  end

  def from_rmxp_serialize(hash)
    hash.each { |key, value| self.instance_variable_set("@#{key}", create_from_rmxp_serialize(value)) }
    self
  end
end

class Numeric
  def rmxp_serialize
    self
  end
end

class String
  def rmxp_serialize
    self
  end
end

class Array
  def rmxp_serialize
    arr = []
    self.each { |e| arr << e.rmxp_serialize }
    arr
  end
end

class Hash
  def rmxp_serialize
    hash = {}
    self.sort.each { |key, value| hash[key] = value.rmxp_serialize }
    hash
  end
end

class TrueClass
  def rmxp_serialize
    self
  end
end

class FalseClass
  def rmxp_serialize
    self
  end
end

class NilClass
  def rmxp_serialize
    self
  end
end

class Color
  attr_accessor :red, :green, :blue, :alpha

  def _dump(limit)
    [@red, @green, @blue, @alpha].pack("d4")
  end

  def self._load(data)
    obj = Color.new
    obj.red, obj.green, obj.blue, obj.alpha = *data.unpack("d4")
    obj
  end
end

class Table
  attr_accessor :num_of_dimensions, :xsize, :ysize, :zsize, :num_of_elements, :elements

  def _dump(limit)
    [@num_of_dimensions, @xsize, @ysize, @zsize, @num_of_elements, @elements].flatten.pack("VVVVVv*")
  end

  def self._load(data)
    obj = self.new
    obj.num_of_dimensions, obj.xsize, obj.ysize, obj.zsize, obj.num_of_elements, *obj.elements = *data.unpack("VVVVVv*")
    obj
  end
end

class Tone
  attr_accessor :red, :green, :blue, :gray

  def _dump(limit)
    [@red, @green, @blue, @gray].pack("d4")
  end

  def self._load(data)
    obj = Tone.new
    obj.red, obj.green, obj.blue, obj.gray = *data.unpack("d4")
    obj
  end
end

module RPG
  class Event
    class Page
      class Condition
      end

      class Graphic
      end
    end
  end

  class EventCommand
  end

  class MoveRoute
  end

  class MoveCommand
  end

  class Map
  end

  class MapInfo
  end

  class AudioFile
  end

  class System
    class Words
    end

    class TestBattler
    end
  end

  class CommonEvent
  end

  class Tileset
  end

  class State
  end

  class Animation
    class Frame
    end

    class Timing
    end
  end

  class Class
    class Learning
    end
  end

  class Actor
  end

  class Skill
  end

  class Item
  end

  class Weapon
  end

  class Armor
  end

  class Enemy
    class Action
    end
  end

  class Troop
    class Member
    end

    class Page
      class Condition
      end
    end
  end
end

class Script
  attr_accessor :id
  attr_accessor :name
  attr_accessor :data
end
