require "yaml"
require "text-adventure-commander"

class TextAdventureLevelManager
  def self.load_config(path)
    config = YAML.load_file("#{Dir.pwd}#{path}")
    load_level("level_0#scene_0", config)
  end

  def self.load_level(id, config)
    level = "_#{id.split("#")[0].split("_")[1]}"
    scene = id.split("#")[1].split("_")[1].to_i

    level_0 = config[level]
    level_0_scene_0 = level_0["scenes"][scene]
    level_0_scene_0_text = level_0_scene_0["text"]
    level_0_scene_0_commands = level_0_scene_0["commands"]
    level_0_scene_0_commands = Hash[*level_0_scene_0_commands.each_slice(2).to_a.flatten]

    commander = TextAdventureCommander.new(level_0_scene_0_commands)
    puts "#{level_0_scene_0_text} #{commander.print_available_commands}"
    input = gets
    recognized = commander.get_commands_from(input)
    recognized.each do |command|
      load_level(level_0_scene_0_commands[command.upcase.tr(" ", "_")], config)
    end
  end
end

TextAdventureLevelManager.load_config("/levels.yml")
