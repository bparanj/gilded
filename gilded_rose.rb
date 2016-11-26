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
    @items.each do |item|
      # "Sulfuras", being a legendary item, never has to be sold and never decreases in Quality
      next if item.name == SULFURAS
      update(item)
    end
  end
  
  private
  
  def update(item)
    update_days_to_expire_for(item)
    update_quality_for(item)
  end

  def update_quality_for(item)
    if item.name == AGED_BRIE
      increment_quality_of(item)
    elsif item.name == BACKSTAGE_PASSES
      increment_quality_of(item)
      if item.sell_in < 10
        increment_quality_of(item)
      end
      if item.sell_in < 5
        increment_quality_of(item)
      end
    elsif item.quality > 0
      item.quality -= 1
    end
    
    if expired?(item)
      if item.name == AGED_BRIE
        increment_quality_of(item)
      elsif item.name == BACKSTAGE_PASSES
        item.quality = item.quality - item.quality
      else
        decrement_quality_of(item)
      end
    end
  end
  
  def decrement_sell_in_days_for(item)
    item.sell_in -= 1
  end
  
  def decrement_quality_of(item)
    # The Quality of an item is never negative
    if item.quality > 0
      item.quality -= 1
    end
  end
  
  def increment_quality_of(item)
    # The Quality of an item is never more than 50
    if item.quality < 50
      item.quality += 1
    end
  end
  # Seems like a bug. We will leave it alone.
  def degrade_quality_twice_for(item)
    item.quality = item.quality - item.quality
  end
  
  def expired?(item)
    item.sell_in < ZERO_DAYS
  end
  
  # Backstage passes increases in Quality as it's SellIn
  # value approaches; Quality increases by 2 when there are 10 days or less
  # and by 3 when there are 5 days or less but Quality drops to 0 after the
  # concert
  def update_quality_for_backstage_passes(item)
    increment_quality_of(item)
    if item.sell_in < ELEVEN_DAYS
      increment_quality_of(item)
    end
    if item.sell_in < SIX_DAYS
      increment_quality_of(item)
    end
  end
  
  def handle_expired(item)
    # Aged Brie actually increases in Quality the older it gets
    if item.name == AGED_BRIE
      increment_quality_of(item)
    elsif item.name != BACKSTAGE_PASSES
      decrement_quality_of(item)
    else
      # Once the sell by date has passed, Quality degrades twice as fast
      degrade_quality_twice_for(item)
    end          
  end
  
  def update_days_to_expire_for(item)
    item.sell_in -= 1
  end
end