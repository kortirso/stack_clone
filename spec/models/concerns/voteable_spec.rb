shared_examples_for 'voteable' do
    it { should have_many(:votes).dependent(:destroy) }

    let(:model) { described_class }
    let!(:user) { create(:user) }

    before do
        @object = create(model.to_s.underscore.to_sym)
    end

    describe 'Before vote' do
        it 'object has sum of votes equal to zero' do
            expect(@object.votes_calc).to eq 0
        end

        it 'and dont has voted users' do
            expect(@object.is_voted?(user)).to eq false
        end
    end

    describe 'After vote' do
        before { create(:vote, voteable: @object, user: user, value: 1) }

        it 'object has sum of votes not equal to zero' do
            expect(@object.votes_calc).to eq 1
        end

        it 'and has a voted user' do
            expect(@object.is_voted?(user)).to eq true
        end

        it 'and user has value of vote' do
            expect(@object.get_vote_value(user)).to eq 1
        end
    end

    describe 'Afrer devote' do
        before do
            create(:vote, voteable: @object, user: user, value: 1)
            @object.devote(user)
        end

        it 'object has sum of votes equal to zero' do
            expect(@object.votes_calc).to eq 0
        end

        it 'and dont has voted users' do
            expect(@object.is_voted?(user)).to eq false
        end
    end
end