require 'spec_helper'

describe GameObject, '#define_properties' do
  context 'given a class derived from GameObject' do
    before { Animal = Class.new(GameObject) }

    context 'when I call #define_properties' do
      before do
        Animal.define_properties :leg_count, :hair_length
      end

      it 'defines a class method named after class name for setting those properties values' do
        expect(Animal).to respond_to(:animal_properties)
      end

      context 'when I call that method' do
        before do
          Animal.animal_properties leg_count: 18
        end

        specify 'property values are accessed via class methods' do
          expect(Animal.leg_count).to eq 18
          expect(Animal.hair_length).to eq nil
        end

        specify 'property values are accessed via instance methods' do
          expect(Animal.new.leg_count).to eq 18
          expect(Animal.new.hair_length).to eq nil
        end
      end

      context 'when two classed derived from that class' do
        before do
          Dog = Class.new(Animal)
          Snake = Class.new(Animal)
        end

        it 'allows different values for the same properties in different children classes' do
          Dog.animal_properties leg_count: 4
          Snake.animal_properties leg_count: 0

          expect(Dog.leg_count).to eq 4
          expect(Snake.leg_count).to eq 0
        end

        it 'allows to define properties of both current class and its parent' do
          Snake.define_properties :length
          Snake.animal_properties leg_count: 0
          Snake.snake_properties length: 1.5

          expect(Snake.leg_count).to eq 0
          expect(Snake.length).to eq 1.5
        end

        it 'allows to access parent properties via child instance' do
          Snake.animal_properties leg_count: 0

          expect(Snake.new.leg_count).to eq 0
        end
      end
    end
  end
end
