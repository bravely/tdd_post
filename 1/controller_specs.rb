require 'rails_helper'

describe WidgetController, type: :controller do
  # These being type: controller means that it loads in a bunch of helpers
  # primarily related to controllers. Models have a few of these, but it's
  # actually very few. Controllers have a ton.

  # Note how this is done- first, the HTTP method, then the Controller instance
  # method that it gets routed to. This helps keep context completely clear.
  describe 'GET #index' do
    let!(:widget) { FactoryGirl.create(:widget) }
    # A bang here since this won't be called in the before block, which is when
    # all of the internal variables will be set.
    context 'as HTML' do
      before do
        # Something to note- this actually isn't /just/ testing the controller
        # method, but in fact, the routing system as well. It boots the whole
        # thing just to run your controller tests. I've never understood why,
        # but keep that in mind.
        get :index

        # So just to explain what this does, in total: It routes through the
        # router to find the controller method(if it's there), then runs the
        # controller method with the simulated parameters. In any controller
        # method, two objects are consistently available: response and request.
        # They're big hashes of all sorts of relevant information that has
        # been collected by Rack along the way, before sending it out to the
        # user. In RSpec controller tests, request is always available(it's
        # often used to set headers), and response is available once a
        # get/post/patch/delete is performed.
      end
      # Status codes are important, and where sometimes you can use a wrong
      # one and get away with it, do attempt to try to avoid it. Wikipedia's
      # list of Status Codes is opened at least twice a week on my machine.
      it { expect(response.status).to eq 200 }
      # This isn't used as often, but can be helpful when your HTML/JSON/CSV
      # endpoints all use the same controller method.
      it { expect(response.content_type).to eq 'text/html' }
      # More on this later.
      it { expect(response).to render_template :index }
      # **Big warning here!** The assigns helper is going away in Rails 5. Yes,
      # it can be added back in a gem, but the reasoning for removing it is
      # actually pretty sound- they're making integration tests faster than
      # controller tests are now, so you'll use those instead.

      # Then again, this is also really easy, and is still a good practice now.
      it { expect(assigns[:widgets]).to include(widget) }
    end
    context 'as JSON' do
      before do
        # Here, we have the format: :json bit. It should be noted, everything
        # that you pass after a symbol-based get/post/patch/delete call, is
        # actually being passed through as parameters. You'll see a clearer idea
        # of this below.
        get :index, format: :json
      end
      it { expect(response.status).to eq 200 }
      it { expect(response.content_type).to eq 'application/json' }
      it { expect(assigns[:widgets]).to include(widget) }
      # The render_template is dodged here, since JSON calls normally don't.
      # The Rails ecosystem has a variety of ways of doing JSON- my
      # personal favorite is ActiveModelSerializers, which is also being
      # included in Rails 5, so give that a shot sometime. It's neato.
    end

    context 'POST #create' do
      context 'as HTML' do
        context 'with proper params' do
          # attributes_for: One of the best methods in FactoryGirl. It's just a
          # hash of the attributes that would be suitable to supply to a model
          # to be consumed so one can be created/updated.
          let(:widget) { FactoryGirl.attributes_for(:widget) }
          before do
            # Security notice: Never, ever, EVER do anything that changes values
            # in a database on the backend in an HTTP GET call. Why?

            # When you were younger, and on MySpace, did you ever suddenly get
            # a friend you never heard of before? Well, turns out MySpace made
            # adding friends a GET request. In the process, it could be put
            # inside of an image, and anyone who visited the page, even if it
            # wasn't on MySpace, would suddenly add you as a friend.

            # You don't want that.

            # Back to testing.
            post :create, widget: widget
          end
          it { expect(response.status).to eq 201 }
          it { expect(response.content_type).to eq 'text/html' }
          it { expect(assigns[:widget].name).to eq widget.name }
          # The below is a fancy way of saying "Does it have an id?"
          it { expect(assigns[:widget]).to be_persisted }
          # This is literally the same thing.
          it { expect(assigns[:widget].id).to_not be_nil }
          # When is it not the same thing? When your primary key in the DB isn't
          # the id. Don't do that. I've never found a reason you would ever do
          # that. It's signing up for trouble in Rails land.

          it { expect(response).to render_template :show }
        end

        context 'with invalid params' do
          # Assuming name's presence is required, of course.
          let(:widget) { FactoryGirl.attributes_for(:widget, name: nil) }
          before do
            post :create, widget: widget
          end
          it { expect(response.status).to eq 422 }
          it { expect(response.content_type).to eq 'text/html' }
          it { expect(assigns[:widget]).to_not be_persisted }
          # To make sure it's retained the information to refill the form
          it { expect(assigns[:widget].feature).to eq widget.feature }
          # To make sure it renders said form
          it { expect(response).to render_template :new }
        end
      end

      context 'as JSON' do
        context 'with proper params' do
          let(:widget) { FactoryGirl.attributes_for(:widget) }
          before do
            # Remember before, how everything afterward is passed as params?
            # Yeah, this is where that matters. Notice how we're passing normal
            # form information through here, right alongside format: :json.

            # This isn't Elixir, where it could figure out where each one
            # belongs. This is its own beast! A mangy animal, really. You're
            # passing straight into params.
            post :create, widget: widget, format: :json
          end
          it { expect(response.status).to eq 201 }
          it { expect(response.content_type).to eq 'application/json' }
          it { expect(assigns[:widget].name).to eq widget.name }
          it { expect(assigns[:widget]).to be_persisted }
        end

        context 'with invalid params' do
          let(:widget) { FactoryGirl.attributes_for(:widget, name: nil) }
          before do
            post :create, widget: widget, format: :json
          end
          it { expect(response.status).to eq 422 }
          it { expect(response.content_type).to eq 'application/json' }
          it { expect(assigns[:widget]).to_not be_persisted }
          it { expect(assigns[:widget].feature).to eq widget.feature }
        end
      end
    end
  end
end
