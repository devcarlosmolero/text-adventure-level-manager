require "yaml"
require "text-adventure-level-manager"

RSpec.describe TextAdventureLevelManager do
  let(:data_root) { "/spec/fixtures" }
  let(:classes_root) { "/spec/fixtures" }
  let(:manager) { TextAdventureLevelManager.new(data_root, classes_root) }

  describe "#initialize" do
    it "loads the levels file" do
      expect(manager.instance_variable_get(:@levels)).not_to be_nil
      expect(manager.instance_variable_get(:@objects)).not_to be_nil
      expect(manager.instance_variable_get(:@enemies)).not_to be_nil
      expect(manager.instance_variable_get(:@classes_root)).not_to be_nil
    end
  end

  describe "#get_level_info" do
    it "returns level information as a hash with symbolized keys" do
      level = manager.get_level(0)
      expect(level).to be_a(Hash)
      expect(level.keys).to all(be_a(Symbol))
    end
  end

  describe "#get_scene_info" do
    it "returns scene information with preloaded objects and enemies" do
      scene = manager.get_scene(0, 0)
      expect(scene).to include(:text, :commands, :objects, :enemies)
    end
  end

  describe "#get_commands_as_hash" do
    it "returns commands as a hash with symbolized keys" do
      scene_commands = [{"command1" => {"action" => "do_something"}}]
      commands_hash = manager.send(:get_commands_as_hash, scene_commands)
      expect(commands_hash).to be_a(Hash)
      expect(commands_hash.keys).to all(be_a(Symbol))
    end
  end

  describe "#parse_level_scene_id" do
    it "parses the level and scene id correctly" do
      level, scene = manager.send(:parse_level_scene_id, "level_1#scene_1")
      expect(level).to eq(1)
      expect(scene).to eq(1)
    end
  end

  describe "#preload_objects" do
    it "preloads objects from the configuration file" do
      object_names = ["Handwritten_Note", "Torch"]
      objects = manager.send(:preload_objects, object_names)
      expect(objects).to all(be_a(Object))
    end
  end

  describe "#preload_enemies" do
    it "preloads enemies from the configuration file" do
      enemy_names = ["Filthy_Rat"]
      enemies = manager.send(:preload_enemies, enemy_names)
      expect(enemies).to all(be_a(Object))
    end
  end
end
