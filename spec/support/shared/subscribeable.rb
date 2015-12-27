shared_examples_for 'subscribeable' do
    it { should have_many(:subscribes).dependent(:destroy) }

    let(:model) { described_class }
    let!(:user) { create :user }

    before do
        @object = create(model.to_s.underscore.to_sym)
    end

    describe 'Before subscribe' do
        it 'object hasnt subscribers' do
            expect(@object.subscribes.count).to eq 1
        end

        it 'and user dont subscribing for it' do
            expect(@object.is_subscribe?(user)).to eq false
        end
    end

    describe 'After subscribe' do
        before { create(:subscribe, subscribeable: @object, user: user) }

        it 'object has subscriber' do
            expect(@object.subscribes.count).to eq 2
        end

        it 'and this subscriber is user' do
            expect(@object.is_subscribe?(user)).to eq true
        end
    end

    describe 'Afrer unsubscribe' do
        before do
            create(:subscribe, subscribeable: @object, user: user)
            @object.unsubscribe(user)
        end

        it 'object hasnt subscribers' do
            expect(@object.subscribes.count).to eq 1
        end

        it 'and user dont subscribing for it' do
            expect(@object.is_subscribe?(user)).to eq false
        end
    end
end