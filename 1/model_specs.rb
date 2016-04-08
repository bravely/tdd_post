require 'rails_helper'

describe MyModel, type: :model do
  # Already, we've set the MyModel class as the subject. This is what the describe
  # block does- it sets the subject. Any sub-describe blocks will either set a new
  # object(it must be a Class object of some kind), or bubble up to the describe
  # block above that. For example,
  describe 'this describe block won\'t hijack the subject' do
    it { expect(true).to be_truthy }
  end

  describe MyModel2 do
    # This will.
    it { expect(true).to be_truthy }
  end

  # Back to testing MyModel. Here are some basic tests available to us:
  it { is_expected.to have_db_column(:foo).of_type(:string) }
  # Yes, you can test for that. But I personally follow a very important rule: Never
  # test your tools. In this case, you're testing both Postgres and Rails to make sure
  # they did their job properly. It's thorough, but is effectively useless and will
  # just take your test-runner extra time.

  # What other things shouldn't you test? I tend to never test scopes ormodule/concern
  # libraries I didn't write.

  # What's a more reasonable test?

  it { is_expected.to validate_presence_of(:foo) }
  # That's right, testing code you put in. After all, you're the one who wanted to
  # `validates :foo, presence: true`.
  it { is_expected.to have_many(:bars) }
  it { is_expected.to belong_to(:baz) }
  # You get the idea.

  # When it comes time to test methods, it's pretty straightforward.
  describe '.bazzes_count' do
    # Just a specific thing: It's common practice to have Class methods be
    # prepended in their describe block with a '.', and instance methods with
    # a '#'.

    # This will be pretty straightforward: It counts the total number of baz objects
    # our MyModel is attached to.
    let(:total) { 5 }
    let!(:bazzes) { FactoryGirl.create_list(:baz, total) }
    it { expect(MyModel.bazzes_count).to eq total }
    # So obviously, things are a little convoluted here, but it's to illustrate
    # a point. For one, you're setting total inside of a let block so that the
    # number can be changed later with minimal code changes. Otherwise, the test
    # is as simple as it looks- you're simply creating the required pieces, then
    # calling the method as easily as possible.
  end

  describe '#boom_half_bars!' do
    # See? This one is called on an instance of the MyModel object.
    let(:associated_total) { 4 }
    let(:my_model) { FactoryGirl.create(:my_model) }
    let(:bars) { FactoryGirl.create_list(:bar, associated_total, my_model: my_model) }
    let!(:other_bar) { FactoryGirl.create(:bar) }
    before do |example|
      return if example.metadata[:skip]
      my_model.boom_half_bars
    end
    it 'destroys half the bar associations', :skip_before do
      expect(my_model.boom_half_bars).to eq(bars - my_model.reload.bars) }
      # So here, we're invoking the method and testing to see what it returns.
      # It's pretty straightforward overall, except that :skip_before parameter
      # at the top. That should be fairly easy to understand though- it does
      # exactly as it says, that key being passed into the metadata hash.
    end
    it 'goes down to the right number of bar associations' do
      expect(my_model.reload.bars.count).to eq (associated_total/2)
    end
    it 'destroys only bars associated with my_model' do
      expect(Bars.count).to eq ((associated_total/2) + 1)
    end
  end
end
