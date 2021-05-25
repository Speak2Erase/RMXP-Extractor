class Color
  attr_accessor :red, :green, :blue, :alpha

  def initialize(hash)
    @red = hash["red"]
    @green = hash["green"]
    @blue = hash["blue"]
    @alpha = hash["alpha"]
  end

  def hash
    dump = {
      red: @red,
      green: @green,
      blue: @blue,
      alpha: @alpha,
    }
  end

  def _dump(limit)
    [@red, @green, @blue, @alpha].pack("EEEE")
  end

  def self._load(obj)
    data = *obj.unpack("EEEE")
    s_hash = {
      red: data[0],
      green: data[1],
      blue: data[2],
      alpha: data[3],
    }
    hash = {}
    s_hash.each do |key, value|
      hash[key.to_s] = value
    end
    Color.new hash
  end
end

class Table
  def initialize(hash, resize = true)
    @num_of_dimensions = hash["dimensions"]
    @xsize = hash["width"]
    @ysize = hash["height"]
    @zsize = hash["depth"]
    @num_of_elements = hash["size"]
    @elements = []
    if @num_of_dimensions > 1 && !resize
      hash["elements"].each_with_index do |value, uindex|
        @elements << []
        value.each_with_index do |value, index|
          @elements[uindex] << eval(value) #!Yep, you can do this to turn strings back into arrays
        end
      end
    else
      @elements = hash["elements"]
    end

    if resize
      if @num_of_dimensions > 1
        if @xsize > 1
          @elements = @elements.each_slice(@xsize).to_a
        else
          @elements = @elements.map { |element| [element] }
        end
      end
      if @num_of_dimensions > 2
        if @ysize > 1
          @elements = @elements.each_slice(@ysize).to_a
        else
          @elements = @elements.map { |element| [element] }
        end
      end
    end
  end

  def hash
    dump = {
      dimensions: @num_of_dimensions,
      width: @xsize,
      height: @ysize,
      depth: @zsize,
      size: @num_of_elements,
      elements: [],
    } #.pack("VVVVVv*")

    if @num_of_dimensions > 1
      @elements.each_with_index do |value, uindex|
        dump[:elements] << []
        value.each_with_index do |value, index|
          dump[:elements][uindex] << value.to_s
        end
      end
    else
      dump[:elements] = *@elements
    end

    dump
  end

  def _dump(limit)
    [@num_of_dimensions, @xsize, @ysize, @zsize, @num_of_elements, *@elements.flatten].pack("VVVVVv*")
  end

  def self._load(obj)
    data = obj.unpack("VVVVVv*")
    @num_of_dimensions, @xsize, @ysize, @zsize, @num_of_elements, *@elements = *data
    s_hash = {
      dimensions: @num_of_dimensions,
      width: @xsize,
      height: @ysize,
      depth: @zsize,
      size: @num_of_elements,
      elements: [],
    }
    hash = {}
    s_hash.each do |key, value|
      hash[key.to_s] = value
    end
    hash["elements"] = *@elements

    Table.new(hash)
  end
end

class Tone
  attr_accessor :red, :green, :blue, :gray

  def initialize(hash = {})
    @red = hash["red"]
    @green = hash["green"]
    @blue = hash["blue"]
    @gray = hash["gray"]
  end

  def hash
    dump = {
      red: @red,
      green: @green,
      blue: @blue,
      gray: @gray,
    }
  end

  def _dump(limit)
    [@red, @green, @blue, @gray].pack("EEEE")
  end

  def self._load(obj)
    data = *obj.unpack("EEEE")
    s_hash = {
      "red": data[0],
      "green": data[1],
      "blue": data[2],
      "gray": data[3],
    }
    hash = {}
    s_hash.each do |key, value|
      hash[key.to_s] = value
    end
    Tone.new hash
  end
end

module RPG
  class Event
    def initialize(hash)
      @id = hash["id"]
      @name = hash["name"]
      @x = hash["x"]
      @y = hash["y"]
      @pages = []
      hash["pages"].each_with_index do |value|
        @pages << RPG::Event::Page.new(value)
      end
    end

    def hash
      dump = {
        id: @id,
        name: @name.force_encoding("iso-8859-1").encode("utf-8"),
        x: @x,
        y: @y,
        pages: [],
      }
      @pages.each_with_index do |value|
        dump[:pages] << value.hash
      end
      dump
    end

    class Page
      def initialize(hash)
        @condition = RPG::Event::Page::Condition.new hash["condition"]
        @graphic = RPG::Event::Page::Graphic.new hash["graphic"]
        @move_type = hash["move_type"]
        @move_speed = hash["move_speed"]
        @move_frequency = hash["move_frequency"]
        @move_route = RPG::MoveRoute.new hash["move_route"]
        @walk_anime = hash["walk_anime"]
        @step_anime = hash["step_anime"]
        @direction_fix = hash["direction_fix"]
        @through = hash["through"]
        @always_on_top = hash["always_on_top"]
        @trigger = hash["trigger"]
        @list = []
        hash["list"].each_with_index do |value|
          @list << RPG::EventCommand.new(value)
        end
      end

      def hash
        dump = {
          condition: "",
          graphic: "",
          move_type: @move_type,
          move_speed: @move_speed,
          move_frequency: @move_frequency,
          move_route: "",
          walk_anime: @walk_anime,
          step_anime: @step_anime,
          direction_fix: @direction_fix,
          through: @through,
          always_on_top: @always_on_top,
          trigger: @trigger,
          list: [],
        }
        @list.each_with_index do |value|
          dump[:list] << value.hash
        end
        dump[:condition] = @condition.hash
        dump[:graphic] = @graphic.hash
        dump[:move_route] = @move_route.hash
        dump
      end

      class Condition
        def initialize(hash)
          @switch1_valid = hash["switch1_valid"]
          @switch2_valid = hash["switch2_valid"]
          @variable_valid = hash["variable_valid"]
          @self_switch_valid = hash["self_switch_valid"]
          @switch1_id = hash["switch1_id"]
          @switch2_id = hash["switch2_id"]
          @variable_id = hash["variable_id"]
          @variable_value = hash["variable_value"]
          @self_switch_ch = hash["self_switch_ch"]
        end

        def hash
          dump = {
            switch1_valid: @switch1_valid,
            switch2_valid: @switch2_valid,
            variable_valid: @variable_valid,
            self_switch_valid: @self_switch_valid,
            switch1_id: @switch1_id,
            switch2_id: @switch2_id,
            variable_id: @variable_id,
            variable_value: @variable_value,
            self_switch_ch: @self_switch_ch,
          }
        end
      end

      class Graphic
        def initialize(hash)
          @tile_id = hash["tile_id"]
          @character_name = hash["character_name"]
          @character_hue = hash["character_hue"]
          @direction = hash["direction"]
          @pattern = hash["pattern"]
          @opacity = hash["opacity"]
          @blend_type = hash["blend_type"]
        end

        def hash
          dump = {
            tile_id: @tile_id,
            character_name: @character_name,
            character_hue: @character_hue,
            direction: @direction,
            pattern: @pattern,
            opacity: @opacity,
            blend_type: @blend_type,
          }
        end
      end
    end
  end

  class EventCommand
    def initialize(hash)
      @code = hash["code"]
      @indent = hash["indent"]
      @parameters = []
      hash["parameters"].each_with_index do |value|
        if value.is_a?(Hash)
          if hash["code"] == 250 || hash["code"] == 249 || hash["code"] == 241 || hash["code"] == 242 || hash["code"] == 245
            @parameters << RPG::AudioFile.new(value)
          elsif hash["code"] == 223 || hash["code"] == 234 || hash["code"] == 205
            @parameters << Tone.new(value)
          elsif hash["code"] == 224
            @parameters << Color.new(value)
          elsif hash["code"] == 509
            @parameters << RPG::MoveCommand.new(value)
          elsif hash["code"] == 209
            @parameters << RPG::MoveRoute.new(value)
          end
        else
          @parameters << value
        end
      end
    end

    def hash
      dump = {
        code: @code,
        indent: @indent,
        parameters: [],
      }
      @parameters.each_with_index do |value|
        if value.to_s.match(/#<RPG::/) || value.to_s.match(/#<Tone:/) || value.to_s.match(/#<Color:/) || value.to_s.match(/#<Table:/)
          dump[:parameters] << value.hash
        elsif value.is_a? String
          if value.encoding.to_s != "UTF-8"
            dump[:parameters] << value.force_encoding("iso-8859-1").encode("utf-8")
          else
            dump[:parameters] << value
          end
        else
          dump[:parameters] << value
        end
      end
      dump
    end
  end

  class MoveRoute
    def initialize(hash)
      @repeat = hash["repeat"]
      @skippable = hash["skippable"]
      @list = []
      hash["list"].each_with_index do |value|
        @list << RPG::MoveCommand.new(value)
      end
    end

    def hash
      dump = {
        repeat: @repeat,
        skippable: @skippable,
        list: [],
      }
      @list.each_with_index do |value|
        dump[:list] << value.hash
      end
      dump
    end
  end

  class MoveCommand
    def initialize(hash)
      @code = hash["code"]
      @parameters = []
      hash["parameters"].each_with_index do |value|
        if value.to_s.match(/#<RPG::/)
          @parameters << RPG::AudioFile.new(value)
        elsif value.to_s.match(/#<Tone:/)
          @parameters << Tone.new(value)
        elsif value.to_s.match(/#<Color:/)
          @parameters << Color.new(value)
        elsif value.to_s.match(/#<Table:/)
          @parameters << Table.new(value, false)
        else
          @parameters << value
        end
      end
    end

    def hash
      dump = {
        code: @code,
        parameters: [],
      }
      @parameters.each_with_index do |value|
        if value.to_s.match(/#<RPG::/) || value.to_s.match(/#<Tone:/) || value.to_s.match(/#<Color:/) || value.to_s.match(/#<Table:/)
          dump[:parameters] << value.hash
        elsif value.is_a? String
          dump[:parameters] << value.force_encoding("iso-8859-1").encode("utf-8")
        else
          dump[:parameters] << value
        end
      end
      dump
    end
  end

  class Map
    def initialize(hash)
      @tileset_id = hash["tileset_id"]
      @width = hash["width"]
      @height = hash["height"]
      @autoplay_bgm = hash["autoplay_bgm"]
      @autoplay_bgs = hash["autoplay_bgs"]
      @bgm = RPG::AudioFile.new hash["bgm"]
      @bgs = RPG::AudioFile.new hash["bgs"]
      @encounter_list = hash["encounter_list"]
      @encounter_step = hash["encounter_step"]
      @data = Table.new(hash["data"], false)
      @events = {}
      events = hash["events"].sort_by { |key| key }.to_h
      events.each do |key, value|
        @events[key.to_i] = RPG::Event.new value
      end
    end

    def hash
      dump = {
        tileset_id: @tileset_id,
        width: @width,
        height: @height,
        autoplay_bgm: @autoplay_bgm,
        bgm: @bgm.hash,
        autoplay_bgs: @autoplay_bgs,
        bgs: @bgs.hash,
        encounter_list: @encounter_list,
        encounter_step: @encounter_step,
        events: {},
        data: @data.hash,
      }
      events = @events.sort_by { |key| key }.to_h
      events.each do |key, value|
        dump[:events][key] = value.hash
      end
      dump
    end
  end

  class MapInfo
    attr_accessor :order

    def initialize(hash)
      @name = hash["name"]
      @parent_id = hash["parent_id"]
      @order = hash["order"]
      @expanded = hash["expanded"]
      @scroll_x = hash["scroll_x"]
      @scroll_y = hash["scroll_y"]
    end

    def hash
      dump = {
        name: @name.force_encoding("iso-8859-1").encode("utf-8"),
        parent_id: @parent_id,
        order: @order,
        expanded: @expanded,
        scroll_x: @scroll_x,
        scroll_y: @scroll_y,
      }
    end
  end

  class AudioFile
    def initialize(hash)
      @name = hash["name"]
      @volume = hash["volume"]
      @pitch = hash["pitch"]
    end

    def hash
      dump = {
        name: @name.force_encoding("iso-8859-1").encode("utf-8"),
        volume: @volume,
        pitch: @pitch,
      }
    end
  end

  class System
    def initialize(hash)
      hash.each do |key, value|
        if value.is_a?(Hash)
          if value["volume"] != nil
            eval("@#{key.to_s}=RPG::AudioFile.new(value)")
          else
            eval("@#{key.to_s}=RPG::System::Words.new(value)")
          end
        else
          eval("@#{key.to_s}=value")
        end
      end
    end

    def hash
      dump = {
        magic_number: @magic_number,
        party_members: @party_members,
        elements: @elements,
        switches: @switches,
        variables: @variables,
        windowskin_name: @windowskin_name,
        title_name: @title_name,
        gameover_name: @gameover_name,
        battle_transition: @battle_transition,

        title_bgm: @title_bgm.hash,
        battle_bgm: @battle_bgm.hash,
        battle_end_me: @battle_end_me.hash,
        gameover_me: @gameover_me.hash,
        cursor_se: @cursor_se.hash,
        decision_se: @decision_se.hash,
        cancel_se: @cancel_se.hash,
        buzzer_se: @buzzer_se.hash,
        equip_se: @equip_se.hash,
        shop_se: @shop_se.hash,
        save_se: @save_se.hash,
        load_se: @load_se.hash,
        battle_start_se: @battle_start_se.hash,
        escape_se: @escape_se.hash,
        actor_collapse_se: @actor_collapse_se.hash,
        enemy_collapse_se: @enemy_collapse_se.hash,

        words: @words.hash,
        test_battlers: [],
        test_troop_id: @test_troop_id,
        start_map_id: @start_map_id,
        start_x: @start_x,
        start_y: @start_y,
        battleback_name: @battleback_name,
        battler_name: @battler_name,
        battler_hue: @battler_hue,
        edit_map_id: @edit_map_id,
      }
      @test_battlers.each_with_index do |value, index|
        dump[:test_battlers] << value.hash
      end
      dump
    end

    class Words
      def initialize(hash)
        hash.each do |key, value|
          eval("@#{key.to_s}=value")
        end
      end

      def hash
        dump = {
          gold: @gold,
          hp: @hp,
          sp: @sp,
          str: @str,
          dex: @dex,
          agi: @agi,
          int: @int,
          atk: @atk,
          pdef: @pdef,
          mdef: @mdef,
          weapon: @weapon,
          armor1: @armor1,
          armor2: @armor2,
          armor3: @armor3,
          armor4: @armor4,
          attack: @attack,
          skill: @skill,
          guard: @guard,
          item: @item,
          equip: @equip,
        }
      end
    end

    class TestBattler
      def hash
        dump = {
          actor_id: @actor_id,
          level: @level,
          weapon_id: @weapon_id,
          armor1_id: @armor1_id,
          armor2_id: @armor2_id,
          armor3_id: @armor3_id,
          armor4_id: @armor4_id,
        }
      end
    end
  end

  class CommonEvent
    def initialize(hash)
      @id = hash["id"]
      @name = hash["name"]
      @trigger = hash["trigger"]
      @switch_id = hash["switch_id"]
      @list = []
      hash["list"].each_with_index do |value|
        @list << RPG::EventCommand.new(value)
      end
    end

    def hash
      dump = {
        id: @id,
        name: @name.force_encoding("iso-8859-1").encode("utf-8"),
        trigger: @trigger,
        switch_id: @switch_id,
        list: [],
      }
      @list.each_with_index do |value|
        dump[:list] << value.hash
      end
      dump
    end
  end

  class Tileset
    def initialize(hash)
      hash.each do |key, value|
        if value.is_a?(Hash)
          eval("@#{key.to_s}=Table.new(value, false)")
        else
          eval("@#{key.to_s}=value")
        end
      end
    end

    def hash
      dump = {
        id: @id,
        name: @name.force_encoding("iso-8859-1").encode("utf-8"),
        tileset_name: @tileset_name,
        autotile_names: @autotile_names,
        panorama_name: @panorama_name,
        panorama_hue: @panorama_hue,
        fog_name: @fog_name,
        fog_hue: @fog_hue,
        fog_opacity: @fog_opacity,
        fog_blend_type: @fog_blend_type,
        fog_zoom: @fog_zoom,
        fog_sx: @fog_sx,
        fog_sy: @fog_sy,
        battleback_name: @battleback_name,
        passages: @passages.hash,
        priorities: @priorities.hash,
        terrain_tags: @terrain_tags.hash,
      }
      dump
    end
  end

  class State
    def initialize(hash)
      hash.each do |key, value|
        eval("@#{key.to_s}=value")
      end
    end

    def hash
      dump = {
        id: @id,
        name: @name.force_encoding("iso-8859-1").encode("utf-8"),
        animation_id: @animation_id,
        restriction: @restriction,
        nonresistance: @nonresistance,
        zero_hp: @zero_hp,
        cant_get_exp: @cant_get_exp,
        cant_evade: @cant_evade,
        slip_damage: @slip_damage,
        rating: @rating,
        hit_rate: @hit_rate,
        maxhp_rate: @maxhp_rate,
        maxsp_rate: @maxsp_rate,
        str_rate: @str_rate,
        dex_rate: @dex_rate,
        agi_rate: @agi_rate,
        int_rate: @int_rate,
        atk_rate: @atk_rate,
        pdef_rate: @pdef_rate,
        mdef_rate: @mdef_rate,
        eva: @eva,
        battle_only: @battle_only,
        hold_turn: @hold_turn,
        auto_release_prob: @auto_release_prob,
        shock_release_prob: @shock_release_prob,
        guard_element_set: @guard_element_set,
        plus_state_set: @plus_state_set,
        minus_state_set: @minus_state_set,
      }
    end
  end

  class Animation
    class Frame
      def initialize(hash)
        @cell_max = hash["cell_max"]
        @cell_data = Table.new hash["cell_data"], false
      end

      def hash
        dump = {
          cell_max: @cell_max,
          cell_data: @cell_data.hash,
        }
      end
    end

    class Timing
      def initialize(hash)
        @frame = hash["frame"]
        @se = RPG::AudioFile.new hash["se"]
        @flash_scope = hash["flash_scope"]
        @flash_color = Color.new hash["flash_color"]
        @flash_duration = hash["flash_duration"]
        @condition = hash["condition"]
      end

      def hash
        dump = {
          frame: @frame,
          se: @se.hash,
          flash_scope: @flash_scope,
          flash_color: @flash_color.hash,
          flash_duration: @flash_duration,
          condition: @condition,
        }
      end
    end

    def initialize(hash)
      @id = hash["id"]
      @name = hash["name"]
      @animation_name = hash["animation_name"]
      @animation_hue = hash["animation_hue"]
      @position = hash["position"]
      @frame_max = hash["frame_max"]
      @frames = []
      @timings = []
      hash["frames"].each_with_index do |value|
        @frames << RPG::Animation::Frame.new(value)
      end
      hash["timings"].each_with_index do |value|
        @timings << RPG::Animation::Timing.new(value)
      end
    end

    def hash
      dump = {
        id: @id,
        name: @name,
        animation_name: @animation_name,
        animation_hue: @animation_hue,
        position: @position,
        frame_max: @frame_max,
        frames: [],
        timings: [],
      }
      @frames.each_with_index do |value|
        dump[:frames] << value.hash
      end
      @timings.each_with_index do |value|
        dump[:timings] << value.hash
      end
      dump
    end
  end

  class Class
    def initialize(hash)
      @id = hash["id"]
      @name = hash["name"]
      @position = hash["position"]
      @weapon_set = hash["weapon_set"]
      @armor_set = hash["armor_set"]
      @element_ranks = Table.new hash["element_ranks"], false
      @state_ranks = Table.new hash["state_ranks"], false
      @learnings = []
      hash["learnings"].each_with_index do |value|
        @learnings << RPG::Class::Learning.new(value)
      end
    end

    class Learning
      def initialize(hash)
        @level = hash["level"]
        @skill_id = hash["skill_id"]
      end

      def hash
        dump = {
          level: @level,
          skill_id: @skill_id,
        }
      end
    end

    def hash
      dump = {
        id: @id,
        name: @name,
        position: @position,
        weapon_set: @weapon_set,
        armor_set: @armor_set,
        element_ranks: @element_ranks.hash,
        state_ranks: @state_ranks.hash,
        learnings: [],
      }
      @learnings.each_with_index do |value|
        dump[:learnings] << value.hash
      end
      dump
    end
  end

  class Actor
    def initialize(hash)
      hash.each do |key, value|
        if value.is_a?(Hash)
          eval("@#{key.to_s}=Table.new(value, false)") #! We know there is only one hash in here so this is fine
        else
          eval("@#{key.to_s}=value")
        end
      end
    end

    def hash
      dump = {
        id: @id,
        name: @name.force_encoding("iso-8859-1").encode("utf-8"),
        class_id: @class_id,
        initial_level: @initial_level,
        final_level: @final_level,
        exp_basis: @exp_basis,
        exp_inflation: @exp_inflation,
        character_name: @character_name,
        character_hue: @character_hue,
        battler_name: @battler_name,
        battler_hue: @battler_hue,
        parameters: @parameters.hash,
        weapon_id: @weapon_id,
        armor1_id: @armor1_id,
        armor2_id: @armor2_id,
        armor3_id: @armor3_id,
        armor4_id: @armor4_id,
        weapon_fix: @weapon_fix,
        armor1_fix: @armor1_fix,
        armor2_fix: @armor2_fix,
        armor3_fix: @armor3_fix,
        armor4_fix: @armor4_fix,
      }
    end
  end

  class Skill
    def initialize(hash)
      hash.each do |key, value|
        if value.is_a?(Hash)
          eval("@#{key.to_s}=RPG::AudioFile.new(value)") #! We know there is only one hash in here so this is fine
        else
          eval("@#{key.to_s}=value")
        end
      end
    end

    def hash
      dump = {
        id: @id,
        name: @name.force_encoding("iso-8859-1").encode("utf-8"),
        icon_name: @icon_name,
        description: @description.force_encoding("iso-8859-1").encode("utf-8"),
        scope: @scope,
        occasion: @occasion,
        animation1_id: @animation1_id,
        animation2_id: @animation2_id,
        menu_se: @menu_se.hash,
        common_event_id: @common_event_id,
        sp_cost: @sp_cost,
        power: @power,
        atk_f: @atk_f,
        eva_f: @eva_f,
        str_f: @str_f,
        dex_f: @dex_f,
        agi_f: @agi_f,
        int_f: @int_f,
        hit: @hit,
        pdef_f: @pdef_f,
        mdef_f: @mdef_f,
        variance: @variance,
        element_set: @element_set,
        plus_state_set: @plus_state_set,
        minus_state_set: @minus_state_set,
      }
      dump
    end
  end

  class Item
    def initialize(hash)
      hash.each do |key, value|
        if value.is_a?(Hash)
          eval("@#{key.to_s}=RPG::AudioFile.new(value)") #! We know there is only one hash in here so this is fine
        else
          eval("@#{key.to_s}=value")
        end
      end
    end

    def hash
      dump = {
        id: @id,
        name: @name.force_encoding("iso-8859-1").encode("utf-8"),
        icon_name: @icon_name,
        description: @description.force_encoding("iso-8859-1").encode("utf-8"),
        scope: @scope,
        occasion: @occasion,
        animation1_id: @animation1_id,
        animation2_id: @animation2_id,
        menu_se: @menu_se.hash,
        common_event_id: @common_event_id,
        price: @price,
        consumable: @consumable,
        parameter_type: @parameter_type,
        parameter_points: @parameter_points,
        recover_hp_rate: @recover_hp_rate,
        recover_hp: @recover_hp,
        hit: @hit,
        pdef_f: @pdef_f,
        mdef_f: @mdef_f,
        variance: @variance,
        element_set: @element_set,
        plus_state_set: @plus_state_set,
        minus_state_set: @minus_state_set,
      }
    end
  end

  class Weapon
    def initialize(hash)
      hash.each do |key, value|
        eval("@#{key.to_s}=value")
      end
    end

    def hash
      dump = {
        id: @id,
        name: @name.force_encoding("iso-8859-1").encode("utf-8"),
        icon_name: @icon_name,
        description: @description.force_encoding("iso-8859-1").encode("utf-8"),
        animation1_id: @animation1_id,
        animation2_id: @animation2_id,
        price: @price,
        atk: @atk,
        pdef: @pdef,
        mdef: @mdef,
        str_plus: @str_plus,
        dex_plus: @dex_plus,
        agi_plus: @agi_plus,
        int_plus: @int_plus,
        element_set: @element_set,
        plus_state_set: @plus_state_set,
        minus_state_set: @minus_state_set,
      }
    end
  end

  class Armor
    def initialize(hash)
      hash.each do |key, value|
        eval("@#{key.to_s}=value")
      end
    end

    def hash
      dump = {
        id: @id,
        name: @name.force_encoding("iso-8859-1").encode("utf-8"),
        icon_name: @icon_name,
        description: @description.force_encoding("iso-8859-1").encode("utf-8"),
        kind: @kind,
        price: @price,
        pdef: @pdef,
        mdef: @mdef,
        eva: @eva,
        str_plus: @str_plus,
        dex_plus: @dex_plus,
        agi_plus: @agi_plus,
        int_plus: @int_plus,
        guard_element_set: @guard_element_set,
        guard_state_set: @guard_state_set,
      }
    end
  end

  class Enemy
    class Action
      def initialize(hash)
        hash.each do |key, value|
          eval("@#{key.to_s}=value")
        end
      end

      def hash
        dump = {
          kind: @kind,
          basic: @basic,
          skill_id: @skill_id,
          condition_turn_a: @condition_turn_a,
          condition_turn_b: @condition_turn_b,
          condition_hp: @condition_hp,
          condition_level: @condition_level,
          condition_switch_id: @condition_switch_id,
          rating: @rating,
        }
      end
    end

    def initialize(hash)
      hash.each do |key, value|
        if value.is_a?(Hash)
          eval("@#{key.to_s}=Table.new(value, false)")
        elsif value.is_a?(Array)
          @actions = []
          value.each_with_index do |value|
            @actions << RPG::Enemy::Action.new(value)
          end
        else
          eval("@#{key.to_s}=value")
        end
      end
    end

    def hash
      dump = {
        id: @id,
        name: @name.force_encoding("iso-8859-1").encode("utf-8"),
        battler_name: @battler_name,
        battler_hue: @battler_hue,
        maxhp: @maxhp,
        maxsp: @maxsp,
        str: @str,
        dex: @dex,
        agi: @agi,
        int: @int,
        atk: @atk,
        pdef: @pdef,
        mdef: @mdef,
        eva: @eva,
        animation1_id: @animation1_id,
        animation2_id: @animation2_id,
        element_ranks: @element_ranks.hash,
        state_ranks: @state_ranks.hash,
        actions: [],
        exp: @exp,
        gold: @gold,
        item_id: @item_id,
        weapon_id: @weapon_id,
        armor_id: @armor_id,
        treasure_prob: @treasure_prob,
      }
      @actions.each_with_index do |value|
        dump[:actions] << value.hash
      end
      dump
    end
  end

  class Troop
    class Member
      def initialize(hash)
        hash.each do |key, value|
          eval("@#{key.to_s}=value")
        end
      end

      def hash
        dump = {
          enemy_id: @enemy_id,
          x: @x,
          y: @y,
          hidden: @hidden,
          immortal: @immortal,
        }
      end
    end

    class Page
      class Condition
        def initialize(hash)
          hash.each do |key, value|
            eval("@#{key.to_s}=value")
          end
        end

        def hash
          dump = {
            turn_valid: @turn_valid,
            enemy_valid: @enemy_valid,
            actor_valid: @actor_valid,
            switch_valid: @switch_valid,
            turn_a: @turn_a,
            turn_b: @turn_b,
            enemy_index: @enemy_index,
            enemy_hp: @enemy_hp,
            actor_id: @actor_id,
            actor_hp: @actor_hp,
            switch_id: @switch_id,
          }
        end
      end

      def initialize(hash)
        @condition = RPG::Troop::Page::Condition.new hash["condition"]
        @span = hash["span"]
        @list = []
        hash["list"].each_with_index do |value|
          @list << RPG::EventCommand.new(value)
        end
      end

      def hash
        dump = {
          condition: @condition.hash,
          span: @span,
          list: [],
        }
        @list.each_with_index do |value|
          dump[:list] << value.hash
        end
        dump
      end
    end

    def initialize(hash)
      @id = hash["id"]
      @name = hash["name"]
      @members = []
      @pages = []

      hash["members"].each_with_index do |value|
        @members << RPG::Troop::Member.new(value)
      end

      hash["pages"].each_with_index do |value|
        @pages << RPG::Troop::Page.new(value)
      end
    end

    def hash
      dump = {
        id: @id,
        name: @name,
        members: [],
        pages: [],
      }
      @members.each_with_index do |value|
        dump[:members] << value.hash
      end
      @pages.each_with_index do |value|
        dump[:pages] << value.hash
      end
      dump
    end
  end
end
