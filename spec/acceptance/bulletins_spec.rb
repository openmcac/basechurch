require "rails_helper"
require "rspec_api_documentation/dsl"

resource "Bulletins" do
  let(:response) { JSON.parse(response_body) }

  def expect_bulletin(payload, model)
    attributes = payload["attributes"]
    expect(payload["id"]).to eq model.id.to_s
    expect(payload["type"]).to eq "bulletins"
    expect(attributes["banner-url"]).to eq model.banner_url
    expect(attributes["name"]).to eq model.name
    expect(attributes["service-order"]).to eq model.service_order
  end

  get "api/v1/sunday" do
    let!(:english_service) { create(:group, :completed, slug: "english-service") }

    let!(:old_bulletin) do
      create(:bulletin, :completed, group: english_service, published_at: 10.days.ago)
    end

    let!(:future_bulletin) do
      create(:bulletin, :completed, group: english_service, published_at: 10.days.from_now)
    end

    example "Show the latest bulletin (with more than 15 minutes before the service starts)" do
      bulletin = create(:bulletin, :completed, group: english_service, published_at: 20.seconds.ago)

      do_request

      expect_bulletin(response["data"], bulletin)
    end

    example "Show the latest bulletin (when it is 15 minutes before the service starts)" do
      bulletin = create(:bulletin, :completed, group: english_service, published_at: 15.minutes.from_now)

      do_request

      expect_bulletin(response["data"], bulletin)
    end
  end

  get "api/v1/bulletins/:id" do
    let(:bulletin) { create(:bulletin, :completed) }
    let(:id) { bulletin.id }

    parameter :id, "The bulletin id", required: true

    example_request "Show a bulletin" do
      expect(status).to eq 200
      expect_bulletin(response["data"], bulletin)
    end
  end

  get "api/v1/bulletins/:id/previous" do
    let(:english_service) { create(:group) }
    let(:bulletin) do
      create(:bulletin,
             :completed,
             group: english_service,
             published_at: DateTime.iso8601('2011-12-03T04:05:06+04:00'))
    end
    let(:id) { bulletin.id }

    parameter :id, "The bulletin id", required: true

    example "Show the previous bulletin" do
      previous_bulletin =
        create(:bulletin,
               :completed,
               group: bulletin.group,
               published_at: DateTime.iso8601('2011-12-02T04:05:06+04:00'))

      do_request

      expect(status).to eq 200
      expect_bulletin(response["data"], previous_bulletin)
    end

    example "Show the previous bulletin (Roll-over)" do
      explanation "When there is no previoius bulletin it rolls over to the last bulletin"

      # post-dated bulletin
      create(:bulletin, group: bulletin.group, published_at: 3.days.from_now)

      last_bulletin =
        create(:bulletin,
               :completed,
               group: bulletin.group,
               published_at: DateTime.now)

      do_request

      expect(status).to eq 200
      expect_bulletin(response["data"], last_bulletin)
    end
  end

  get "api/v1/bulletins/:id/next" do
    let(:english_service) { create(:group) }
    let(:bulletin) do
      create(:bulletin,
             :completed,
             group: english_service,
             published_at: DateTime.iso8601('2011-12-03T04:05:06+04:00'))
    end
    let(:id) { bulletin.id }

    parameter :id, "The bulletin id", required: true

    example "Show the next bulletin" do
      next_bulletin =
        create(:bulletin,
               :completed,
               group: bulletin.group,
               published_at: DateTime.iso8601('2011-12-05T04:05:06+04:00'))

      do_request

      expect(status).to eq 200
      expect_bulletin(response["data"], next_bulletin)
    end

    example "Show the next bulletin (Roll-over)" do
      explanation "When there is no next bulletin it rolls over to the first bulletin"

      first_bulletin =
        create(:bulletin,
               :completed,
               group: bulletin.group,
               published_at: bulletin.published_at - 10.days)

      do_request

      expect(status).to eq 200
      expect_bulletin(response["data"], first_bulletin)
    end
  end

  post "api/v1/bulletins" do
    let(:group) { create(:group) }
    let(:response) { JSON.parse(response_body) }

    parameter :type,
      "The type of resource to update",
      scope: [:data],
      required: true

    parameter "published-at",
      "The publish date of the bulletin in iso8601 format",
      scope: [:data, :attributes],
      required: true

    parameter "banner-url",
      "The banner of the bulletin",
      scope: [:data, :attributes]

    parameter :name, "The bulletin name", scope: [:data, :attributes]
    parameter "service-order".to_sym,
      "The bulletin service order",
      scope: [:data, :attributes]

    parameter :type,
      "The group type",
      scope: [:data, :relationships, :group, :data],
      required: true

    parameter :id,
      "The associated group id",
      scope: [:data, :relationships, :group, :data],
      required: true

    let(:data_type) { "bulletins" }
    let(:data_attributes_published_at) { DateTime.now }
    let("data_attributes_published-at".to_sym) do
      data_attributes_published_at.to_time.localtime("+00:00").iso8601
    end
    let("data_attributes_banner-url".to_sym) do
      "http://example.org/banner.png"
    end
    let(:data_attributes_name) { "Random Service Name" }
    let("data_attributes_service-order".to_sym) { data_attributes_service_order }
    let("data_attributes_service_order") { "Hello world!" }
    let(:data_relationships_group_data_type) { "groups" }
    let(:data_relationships_group_data_id) { group.id.to_s }

    subject { Bulletin.find(response["data"]["id"]) }

    example_authenticated_request "Create a bulletin" do
      expect(status).to eq 201

      expect(subject.published_at.to_time.localtime("+00:00").iso8601).
        to eq data_attributes_published_at.to_time.localtime("+00:00").iso8601
      expect(subject.name).to eq data_attributes_name
      expect(subject.service_order).to eq data_attributes_service_order
      expect(subject.group).to eq group

      expect_bulletin(response["data"], subject)
    end

    example_authenticated_request "Create a bulletin (invalid parameters)",
      "data" => { "attributes" => { "published-at" => "" } } do
      expect(status).to eq 422
    end
  end

  get "api/v1/bulletins/sign" do
    let(:directory) { "bulletins" }
    it_behaves_like "an endpoint that returns a signature to upload to s3" 
  end
end
