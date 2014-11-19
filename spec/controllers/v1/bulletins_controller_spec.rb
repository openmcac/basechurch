require 'rails_helper'

describe V1::BulletinsController do
  let(:sunday_service) do
    create(:group)
  end

  let(:user) { create(:user) }

  let(:all_attributes) do
    {
      bulletin: {
        publishedAt: DateTime.now.to_time.iso8601,
        name: Forgery(:lorem_ipsum).title,
        description: Forgery(:lorem_ipsum).words(10),
        serviceOrder: Forgery(:lorem_ipsum).words(10)
      },
      group_id: sunday_service.id
    }
  end

  let(:valid_attributes) do
    {
      bulletin: {
        publishedAt: DateTime.now.to_time.iso8601
      },
      group_id: sunday_service.id
    }
  end

  shared_examples_for 'an action to create a bulletin' do
    let(:perform_create) { post :create, post_params }

    it 'creates a new bulletin' do
      expect { perform_create }.to change { Bulletin.count }.by(1)
    end

    it 'returns the created bulletin' do
      perform_create

      expect(response.body).
          to eq(BulletinSerializer.new(Bulletin.last).to_json)
    end
  end

  describe 'GET /:group_slug/bulletins/:id' do
    let(:bulletin) { create(:bulletin) }

    it 'returns a single bulletin' do
      get :show, id: bulletin.id, group_id: bulletin.group_id
      expect(response.body).to eq(BulletinSerializer.new(bulletin).to_json)
    end
  end

  describe 'POST /:group_slug/bulletins' do
    context 'with an authenticated user' do
      before { sign_in user }

      context 'with minimum params required' do
        let(:post_params) { valid_attributes }
        it_behaves_like 'an action to create a bulletin'
      end

      context 'with all params provided' do
        let(:post_params) { all_attributes }
        it_behaves_like 'an action to create a bulletin'
      end

      context 'with invalid parameters' do
        let(:invalid_attributes) { valid_attributes }
        let(:perform_create) { post :create, valid_attributes }

        context "where published_at is not iso8601 compliant" do
          before do
            invalid_attributes[:bulletin][:publishedAt] = 'sdafasdfdsa'
            perform_create
          end

          subject { response }

          its(:status) { should == 422 }
        end
      end
    end

    context 'with an anonymous user' do
      before { post :create, valid_attributes }

      it 'returns a 302 status code' do
        expect(response.status).to eq(302)
      end

      it 'does not create a bulletin' do
        expect { post :create, valid_attributes }.
            to_not change { Bulletin.count }
      end
    end
  end
end
