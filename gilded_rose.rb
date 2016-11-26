require_relative 'item.rb'

class GildedRose
  BACKSTAGE_PASSES = 'Backstage passes to a TAFKAL80ETC concert'
  SULFURAS = 'Sulfuras, Hand of Ragnaros'
  AGED_BRIE = 'Aged Brie'
  
  ELEVEN_DAYS = 11
  SIX_DAYS = 6
  ZERO_DAYS = 0
  
  @items = []
  
  def initialize
    @items = []
    @items << Item.new("+5 Dexterity Vest", 10, 20)
    @items << Item.new(AGED_BRIE, 2, 0)
    @items << Item.new("Elixir of the Mongoose", 5, 7)
    @items << Item.new(SULFURAS, 0, 80)
    @items << Item.new(BACKSTAGE_PASSES, 15, 20)
    @items << Item.new("Conjured Mana Cake", 3, 6)
  end

  def update_quality
    for i in 0..(@items.size-1)
      if (@items[i].name != AGED_BRIE && @items[i].name != BACKSTAGE_PASSES)
        if (@items[i].quality > 0)
          if (@items[i].name != SULFURAS)
            @items[i].quality -= 1
          end
        end
      else
        if (@items[i].quality < 50)
          @items[i].quality += 1
          if (@items[i].name == BACKSTAGE_PASSES)
            if (@items[i].sell_in < ELEVEN_DAYS)
              if (@items[i].quality < 50)
                @items[i].quality += 1
              end
            end
            if (@items[i].sell_in < SIX_DAYS)
              if (@items[i].quality < 50)
                @items[i].quality += 1
              end
            end
          end
        end
      end
      if (@items[i].name != SULFURAS)
        @items[i].sell_in -= 1;
      end
      if (@items[i].sell_in < ZERO_DAYS)
        if (@items[i].name != AGED_BRIE)
          if (@items[i].name != BACKSTAGE_PASSES)
            if (@items[i].quality > 0)
              if (@items[i].name != SULFURAS)
                @items[i].quality -= 1
              end
            end
          else
            @items[i].quality = @items[i].quality - @items[i].quality
          end
        else
          if (@items[i].quality < 50)
            @items[i].quality += 1
          end
        end
      end
    end
  end
end