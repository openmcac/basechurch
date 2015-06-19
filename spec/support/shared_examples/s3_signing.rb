# variables
#  - directory
shared_examples_for "a request that returns a signature to upload to s3" do
  describe "#sign" do
    context "when unauthenticated" do
      before do
        get :sign, name: "myfile.jpg", size: 12343, type: "image/jpeg"
      end

      it "requires authentication" do
        expect(response.status).to eq(302)
      end
    end

    context "with a signed in user" do
      let(:signed_hash) { { "random" => "hash" } }

      before do
        sign_in user

        allow_any_instance_of(S3Signer).to receive(:sign).
          with(type: "image/jpeg", directory: directory).
          and_return(signed_hash)

        get :sign, name: "myfile.jpg", size: 12343, type: "image/jpeg"
      end

      it "responds with values to post to s3" do
        expect(JSON.parse(response.body)).to eq signed_hash
      end
    end
  end
end
