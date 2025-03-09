require "yaml"

class TextAdventureLevelManager
  def initialize(data_root, classes_root)
    @levels = YAML.load_file("#{Dir.pwd}#{data_root}/levels.yml")
    @objects = YAML.load_file("#{Dir.pwd}#{data_root}/objects.yml")
    @enemies = YAML.load_file("#{Dir.pwd}#{data_root}/enemies.yml")

    @classes_root = classes_root
  end

  def get_level(level_id)
    level_key = "_#{level_id}"
    @levels[level_key].transform_keys(&:to_sym)
  end

  def get_scene(level_id, scene_index)
    level = get_level(level_id)
    scene = level[:scenes][scene_index].transform_keys(&:to_sym)
    {
      text: scene[:text],
      commands: scene[:commands],
      objects: preload_objects(scene[:objects]),
      enemies: preload_enemies(scene[:enemies])
    }
  end

  private

  def get_commands_as_hash(scene_commands)
    commands_hash = scene_commands.each_with_object({}) do |command_group, result|
      command_group.each do |key, value|
        next if value.nil?
        normalized_key = key.to_sym
        normalized_value = value.transform_keys(&:to_sym)
        result[normalized_key] = normalized_value
      end
    end
    commands_hash.merge(SEARCH_AROUND: {type: "search"})
  end

  def parse_level_scene_id(id)
    level = id.split("#")[0].split("_")[1].to_i
    scene = id.split("#")[1].split("_")[1].to_i
    [level, scene]
  end

  def preload_objects(object_names)
    return [] if object_names.nil?
    object_names.map do |object_name|
      object = @objects[object_name]
      object_class_name = object_name.tr("_", "")
      require "#{Dir.pwd}#{@classes_root}/objects/#{object_name.downcase}"
      case object["type"]
      when "note"
        Object.const_get(object_class_name).new(object["content"])
      when "weapon"
        Object.const_get(object_class_name).new(object["stats"])
      when "actionable"
        Object.const_get(object_class_name).new
      end
    end
  end

  def preload_enemies(enemy_names)
    return [] if enemy_names.nil?
    enemy_names.map do |enemy_name|
      enemy = @enemies[enemy_name]
      enemy_class_name = enemy_name.tr("_", "")
      require "#{Dir.pwd}#{@classes_root}/enemies/#{enemy_name.downcase}"
      Object.const_get(enemy_class_name).new(enemy["stats"])
    end
  end
end
