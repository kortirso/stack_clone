shared_examples_for 'commentable' do
    it { should have_many(:comments).dependent(:destroy) }

    let(:model) { described_class }
    let!(:user) { create(:user) }

    before do
        @object = create(model.to_s.underscore.to_sym)
    end
end