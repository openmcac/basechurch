# variables
#  - directory
shared_examples_for "an endpoint that returns a signature to upload to s3" do
  parameter :name, "Attachment filename"
  parameter :size, "Attachment filesize in kb"
  parameter :type, "Attachment file type"

  let(:signed_hash) do
    S3Signer.new.sign(type: "image/jpeg", directory: directory)
  end

  before do
    allow_any_instance_of(S3Signer).to receive(:sign).
      with(type: "image/jpeg", directory: directory).
      and_return(signed_hash)
  end

  example_authenticated_request"Signing attachments",
    name: "myfile.jpg", size: 123, type: "image/jpeg" do
    expect(status).to eq 200
    expect(response.as_json).to eq signed_hash.as_json
  end
end
