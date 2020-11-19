require 'test_helper'

class SpellsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @spell = spells(:one)
  end

  test "should get index" do
    get spells_url, as: :json
    assert_response :success
  end

  test "should create spell" do
    assert_difference('Spell.count') do
      post spells_url, params: { spell: { area_of_effect: @spell.area_of_effect, attack_type: @spell.attack_type, casting_time: @spell.casting_time, classes: @spell.classes, components: @spell.components, concentration: @spell.concentration, damage_at_slot_level: @spell.damage_at_slot_level, dc: @spell.dc, desc: @spell.desc, duration: @spell.duration, higher_level: @spell.higher_level, level: @spell.level, material: @spell.material, name: @spell.name, range: @spell.range, ritual: @spell.ritual, school: @spell.school } }, as: :json
    end

    assert_response 201
  end

  test "should show spell" do
    get spell_url(@spell), as: :json
    assert_response :success
  end

  test "should update spell" do
    patch spell_url(@spell), params: { spell: { area_of_effect: @spell.area_of_effect, attack_type: @spell.attack_type, casting_time: @spell.casting_time, classes: @spell.classes, components: @spell.components, concentration: @spell.concentration, damage_at_slot_level: @spell.damage_at_slot_level, dc: @spell.dc, desc: @spell.desc, duration: @spell.duration, higher_level: @spell.higher_level, level: @spell.level, material: @spell.material, name: @spell.name, range: @spell.range, ritual: @spell.ritual, school: @spell.school } }, as: :json
    assert_response 200
  end

  test "should destroy spell" do
    assert_difference('Spell.count', -1) do
      delete spell_url(@spell), as: :json
    end

    assert_response 204
  end
end
