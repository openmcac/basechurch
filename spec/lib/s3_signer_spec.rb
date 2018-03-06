require "rails_helper"

describe S3Signer do
  describe "#sign" do
    let(:signed) do
      Timecop.freeze(DateTime.iso8601("2013-05-13T22:18:26-04:00")) do
        S3Signer.new.
          sign(type: "image/jpeg", directory: "bulletins").
          with_indifferent_access
      end
    end

    let(:policy) do
      "eyJleHBpcmF0aW9uIjoiMjAxMy0wNS0xNFQwMjo0ODoyNi4wMDBaIiwiY29uZGl0a" +
        "W9ucyI6W3siYnVja2V0IjoibWNhYy10ZXN0In0seyJhY2wiOiJwdWJsaWMtcmVhZC" +
        "J9LHsiZXhwaXJlcyI6IjIwMTMtMDUtMTRUMDI6NDg6MjYuMDAwWiJ9LHsic3VjY2V" +
        "zc19hY3Rpb25fc3RhdHVzIjoiMjAxIn0sWyJzdGFydHMtd2l0aCIsIiRrZXkiLCIi" +
        "XSxbInN0YXJ0cy13aXRoIiwiJENvbnRlbnQtVHlwZSIsIiJdLFsic3RhcnRzLXdpd" +
        "GgiLCIkQ2FjaGUtQ29udHJvbCIsIiJdLFsiY29udGVudC1sZW5ndGgtcmFuZ2UiLD" +
        "AsNTI0Mjg4MDAwXV19"
    end

    before do
      allow_any_instance_of(RandomFilename).to receive(:generate).
        and_return("random.jpg")
    end

    it "creates signed request for s3" do
      expect(signed[:acl]).to eq "public-read"
      expect(signed[:awsAccessKeyId]).to eq ENV["aws_access_key_id"]
      expect(signed[:bucket]).to eq "mcac-test"
      expect(signed["Cache-Control"]).to eq "max-age=630720000, public"
      expect(signed["Content-Type"]).to eq "image/jpeg"
      expect(signed[:expires]).to eq "2013-05-14T02:48:26.000Z"
      expect(signed[:key]).to eq "bulletins/random.jpg"
      expect(signed[:policy]).to eq policy
      expect(signed[:signature]).to eq "IS1HheFL3YkG/kr0hMyzwphOmNM="
      expect(signed[:success_action_status]).to eq "201"
    end
  end
end
