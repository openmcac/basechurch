require 'rails_helper'

describe V1::BulletinsController do
  let(:sunday_service) do
    create(:group)
  end

  let(:valid_attributes) do
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

  describe 'GET /:group_slug/bulletins/:id' do
    let(:bulletin) { create(:bulletin) }

    it 'returns a single bulletin' do
      get :show, id: bulletin.id, group_id: bulletin.group_id
      expect(response.body).to eq(BulletinSerializer.new(bulletin).to_json)
    end
  end

  describe 'POST /:group_slug/bulletins' do
    context 'with valid params' do
      let(:perform_create) { post :create, valid_attributes }

      it 'creates a new bulletin' do
        expect { perform_create }.to change { Bulletin.count }.by(1)
      end

      it 'returns the created bulletin' do
        perform_create

        expect(response.body).
            to eq(BulletinSerializer.new(Bulletin.last).to_json)
      end
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
end
