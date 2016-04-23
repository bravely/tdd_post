require 'rails_helper'

describe 'search' do
  # Note that since these are full integration tests, we don't go by the
  # controller method, but the route.
  describe 'GET /search' do
    # HTML Request specs work best when utilizing the gem, Webrat. Capybara
    # installs webrat by default, but you can use just the Webrat matchers
    # if you want- as we will here.
    context 'as HTML' do
      let!(:result) { FactoryGirl.create(:result, name: 'yes') }
      let!(:nope)   { FactoryGirl.create(:result, name: 'nope') }
      before do
        # Note we're passing the query parameters as an argument to the path.
        get search_path query: 'yes'
      end
      it { expect(response.status).to eq 200 }
      it { expect(response.content_type).to eq 'text/html' }
      # Here, we're using the core Webrat matcher you'll want to utilize in
      # request specs: have_selector. Think of it like a check for a JQuery
      # object, if you were in Javascript.
      it { expect(response.body).to have_selector '.result', count: 1 }
      it { expect(response.body).to have_selector "\#result_#{result.id}" }
      it { expect(response.body).to_not have_selector "\#result_#{nope.id}" }
    end

    context 'as JSON' do
      let!(:result) { FactoryGirl.create(:result, name: 'yes') }
      let!(:nope)   { FactoryGirl.create(:result, name: 'nope') }
      before do
        # Notice again. All the format: :json does here is change the request
        # to a ''/search?query=yes.json'.
        get search_path 'yes', format: :json

        # The following is often put into a spec support file. In Rails 5,
        # it won't be required as instead you can just call
        # response.parsed_body.
        json = JSON.parse(response.body)
      end
      it { expect(response.status).to eq 200 }
      it { expect(response.content_type).to eq 'application/json' }
      # Here, we use the above parsed results. Notice
      it { expect(json['results'].length).to eq 1 }
      it { expect(json['results'].first['name']).to eq result.name }
      it 'does not show an irrelevant result' do
        expect(
          json['results'].select { |r| r['id'].to_i == nope.id }
        ).to be_empty
      end
    end
  end
end
