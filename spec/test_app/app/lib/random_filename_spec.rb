require "rails_helper"

describe RandomFilename do
  before { allow(SecureRandom).to receive(:uuid).and_return("uuid") }

  describe ".for_file_type" do
    subject { RandomFilename.new(file_type).generate }

    context "when file type is image/jpeg" do
      let(:file_type) { "image/jpeg" }

      it { is_expected.to eq "uuid.jpg" }
    end
  end
end
