class FightClubItemImportService
  def execute()
    import_items
  end

  def import_items
    items = Adapters::FightClubFiveEAdapter.retrieve_resource_collection('items')
    items.each{|item|
      item_attributes = build_item(item)
      new_item = Item.create!(item_attributes)
    }
  end

  private

  def build_item(item)
    @item = item
    item_attributes = {
      name: name,
      details: details,
      item_type: item_type,
      stealth: stealth,
      magic: magic,
      ac: ac,
      weight: weight,
      value: value,
      property: property,
      damage: damage,
      dmg_type: dmg_type,
      rolls: rolls
    }
    return item_attributes
  end

  def name
    @item['name']
  end

  def desc
    @item['text']
  end

  def details
    @item['detail']
  end

  def item_type
    @item['type']
  end

  def magic
    @item['magic'].present?
  end

  def stealth
    @item['stealth'].present?
  end

  def weight
    @item['weight'].present? ? @item['weight'] : 0
  end

  def value
    @item['value'].present? ? @item['value'] : 0
  end

  def property
    @item['property'].present? ? @item['property'] : nil
  end

  def ac
    @item['ac'].present? ? @item['ac'] : nil
  end

  def dmg_type
    @item['dmgType'] if @item['dmgType'].present?
  end

  def damage
    damage_string = ''
    if @item['dmg1'].present?
      damage_string += @item['dmg1']
      if @item['dmg2'].present?
        damage_string += @item['dmg2']
      end
    end
    return damage_string.empty? ? nil : damage_string
  end

  def rolls
    unless @item['roll'].nil?
      @item['roll'].kind_of?(Array) ? @item['roll'].join("\n") : @item['roll']
    else
      return nil
    end
  end

end
