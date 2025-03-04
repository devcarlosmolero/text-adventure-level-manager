require "yaml"
require "text-adventure-commander"
require "../lib/objects/base_object"
require "../lib/objects/sword"

class TextAdventureLevelManager
  def self.load_config(path)
    config = YAML.load_file("#{Dir.pwd}#{path}")
    load_level("level_0#scene_0", config)
  end

  def self.load_level(id, config)
    level = "_#{id.split("#")[0].split("_")[1]}"
    scene = id.split("#")[1].split("_")[1].to_i

    level_data = config[level].transform_keys(&:to_sym)
    scene_data = level_data[:scenes][scene].transform_keys(&:to_sym)

    scene_text = scene_data[:text]
    scene_commands = scene_data[:commands]

    commands_hash = scene_commands.each_with_object({}) do |command_group, result|
      command_group.each do |key, value|
        next if value.nil?
        normalized_key = key.to_sym
        normalized_value = value.transform_keys(&:to_sym)
        result[normalized_key] = normalized_value
      end
    end

    full_commands_hash = commands_hash.merge(SEARCH_AROUND: {type: "search"})

    commander = TextAdventureCommander.new(full_commands_hash)
    puts "#{scene_text} #{commander.print_available_commands}"

    input = gets.chomp
    recognized = commander.get_commands_from(input)
    recognized.each do |command|
      cmd = commander.get_command(command.to_s)
      case cmd[:type]
      when "navigation"
        load_level(cmd[:to], config)
      when "search"
        puts "Search!"
      end
    end
  end
end

TextAdventureLevelManager.load_config("/levels.yml")
