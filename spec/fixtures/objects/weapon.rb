require_relative "usable_object"

class Weapon
  include UsableObject

  attr_accessor :attack, :durability

  def initialize(attack, durability)
    @attack = attack
    @durability = durability
  end

  def use
    @durability -= 1
  end
end
