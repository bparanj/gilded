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

  # Backstage passes, like aged brie, increases in Quality as it's SellIn
  #     value approaches; Quality increases by 2 when there are 10 days or less
  #     and by 3 when there are 5 days or less but Quality drops to 0 after the
  #     concert
  def update_quality
    for i in 0..(@items.size-1)
      if (@items[i].name != AGED_BRIE && @items[i].name != BACKSTAGE_PASSES)
        if (@items[i].quality > 0)
          # "Sulfuras", being a legendary item, never decreases in Quality
          if (@items[i].name != SULFURAS)
            decrement_quality_of(@items[i])
          end
        end
      else
        # The Quality of an item is never more than 50
        if (@items[i].quality < 50)
          @items[i].quality += 1
          if (@items[i].name == BACKSTAGE_PASSES)
            if (@items[i].sell_in < ELEVEN_DAYS)
              if (@items[i].quality < 50)
                increment_quality_of(@items[i])
              end
            end
            if (@items[i].sell_in < SIX_DAYS)
              if (@items[i].quality < 50)
                increment_quality_of(@items[i])
              end
            end
          end
        end
      end
      # "Sulfuras", being a legendary item, never has to be sold 
      if (@items[i].name != SULFURAS)
        @items[i].sell_in -= 1;
      end
      # Expired item
      if (@items[i].sell_in < ZERO_DAYS)
        # "Aged Brie" actually increases in Quality the older it gets
        if (@items[i].name != AGED_BRIE)
          if (@items[i].name != BACKSTAGE_PASSES)
            if (@items[i].quality > 0)
              # "Sulfuras", being a legendary item, never decreases in Quality
              if (@items[i].name != SULFURAS)
                decrement_quality_of(@items[i])
              end
            end
          else
            # Once the sell by date has passed, Quality degrades twice as fast
            @items[i].quality = @items[i].quality - @items[i].quality
          end
        else
          # The Quality of an item is never more than 50
          if (@items[i].quality < 50)
            increment_quality_of(@items[i])
          end
        end
      end
    end
  end
  
  def decrement_quality_of(item)
    item.quality -= 1
  end
  
  def increment_quality_of(item)
    item.quality += 1
  end
end