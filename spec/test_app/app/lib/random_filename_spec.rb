require "rails_helper"

describe RandomFilename do
  before { allow(SecureRandom).to receive(:uuid).and_return("uuid") }

  describe ".for_file_type" do
    subject { RandomFilename.new(file_type).generate }

    context "when file type is image/jpeg" do
      let(:file_type) { "image/jpeg" }

      it { is_expected.to eq "uuid.jpg" }
    end

    context "when file type is audio/mpeg" do
      let(:file_type) { "audio/mpeg" }

      it { is_expected.to eq "uuid.mp3" }
    end

    context "when file type is audio/mpeg3" do
      let(:file_type) { "audio/mpeg3" }

      it { is_expected.to eq "uuid.mp3" }
    end

    context "when file type is audio/mp3" do
      let(:file_type) { "audio/mp3" }

      it { is_expected.to eq "uuid.mp3" }
    end
  end
end
