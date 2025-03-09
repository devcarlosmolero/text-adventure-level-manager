require_relative "weapon"

class DustySword < Weapon
  def initialize(stats)
    super(stats[:attack], stats[:durability])
  end
end
