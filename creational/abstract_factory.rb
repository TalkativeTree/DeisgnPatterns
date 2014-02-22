module AbstractMerchandiseFactorySend
  class << self
    def create(merch_type, **merch_details)
      self.send(merch_type, merch_details) if the_store_carries?(merch_type)
    end

    def videogame(**details)
      VideoGame.new(details)
    end

    def boardgame(**details)
      BoardGame.new(details)
    end

    def gamesystem(**details)
      GameSystem.new(details)
    end

    def controller(**details)
      Controller.new(details)
    end

    private
    def the_store_carries?(item)
      [:video_game, :board_game, :game_system, :controller].include?(item)
    end
  end
end

module AbstractMerchandiseFactoryConstGet
  class << self
    def create(merch_type, **merch_details)
      Merchandise.const_get( canonicalize(merch_type) ).new(merch_details)
    end

    private

    def canonicalize(name)
      name.to_s.split("_").map{|word| word.capitalize}.join('')
    end

  end
end

class GameStore
  def initialize(inventory)
    @catalog = Catalog.new()
    @inventory = inventory.map{ |item| AbstractMerchandiseFactoryConstGet.create(item)}
  end

  def add(item, **details)
    @inventory << AbstractMerchandiseFactoryConstGet.create(item, details)
  end
end


class Catalog < Struct.new(:items)
  def add(item)
    @items << item if !@items.include?(item)
  end

  def remove(item)
    @items.delete(item)
  end
end

module Merchandise
  class VideoGame
    def initialize(**details)
      @title = details[:name] || "VideoGame"
      @cost  = details[:cost] || 50.00
    end
  end

  class BoardGame
    def initialize(**details)
      @title = details[:name] || "BoardGame"
      @cost  = details[:cost] || 24.50
    end
  end

  class GameSystem
    def initialize(**details)
      @title = details[:name] || "GameSystem"
      @cost  = details[:cost] || 299.00
    end
  end

  class Controller
    def initialize(**details)
      @title = details[:name] || "Controller"
      @cost  = details[:cost] || 24.50
    end
  end
end

gs = GameStore.new([:video_game, :board_game, :game_system, :controller])
gs.add(:video_game, name: "League of Legends", cost: 0)

p gs
