require 'rails_helper'

describe V1::BulletinsController do
  let(:valid_attributes) do
    {
      bulletin: {
        publishedAt: DateTime.now.to_time.iso8601,
        name: Forgery(:lorem_ipsum).title,
        description: Forgery(:lorem_ipsum).words(10),
        serviceOrder: Forgery(:lorem_ipsum).words(10)
      }
    }
  end

  describe 'GET /bulletins/:id' do
    let(:bulletin) { create(:bulletin) }

    it 'returns a single bulletin' do
      get :show, id: bulletin.id
      expect(response.body).to eq(BulletinSerializer.new(bulletin).to_json)
    end
  end

  describe 'POST /bulletins' do
    context 'with valid params' do
      let(:create) { post :create, valid_attributes }

      it 'creates a new bulletin' do
        expect { create }.to change { Bulletin.count }.by(1)
      end

      it 'returns the created bulletin' do
        create

        bulletin_hash = valid_attributes[:bulletin]

        bulletin = Bulletin.new
        bulletin.id = Bulletin.last.id
        bulletin.name = bulletin_hash[:name]
        bulletin.published_at = DateTime.iso8601(bulletin_hash[:publishedAt])
        bulletin.description = bulletin_hash[:description]
        bulletin.service_order = bulletin_hash[:serviceOrder]

        expect(response.body).to eq(BulletinSerializer.new(bulletin).to_json)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { valid_attributes }
      let(:create) { post :create, valid_attributes }

      context "where published_at is not iso8601 compliant" do
        before do
          invalid_attributes[:bulletin][:publishedAt] = 'sdafasdfdsa'
          create
        end

        subject { response }

        its(:status) { should == 422 }
      end
    end
  end
end
