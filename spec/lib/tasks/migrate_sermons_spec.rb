require 'rails_helper'
require "tasks/migrate_sermons"

RSpec.describe MigrateSermons, type: :model do
  context "with a bulletin that does not have an audio file" do
    subject(:process) { MigrateSermons.new.process }

    before do
      create(:bulletin)
    end

    it "does not migrate into a sermon" do
      expect { process }.not_to change { Sermon.count }
    end
  end

  context "with a bulletin that does have an audio file" do
    subject { Sermon.last }

    context "when the bulletin doesn't mention any expected speakers" do
      let!(:bulletin) do
        create(:bulletin,
               audio_url: "http://nba.com/audio.mp3",
               published_at: DateTime.now,
               sermon_notes: "These are sermon notes",
               description: "random desc")
      end

      before { MigrateSermons.new.process }

      it "migrates a sermon from the bulletin" do
        expect(subject.audio_url).to eq bulletin.audio_url
        expect(subject.group_id).to eq bulletin.group_id
        expect(subject.notes).to eq bulletin.sermon_notes
        expect(subject.published_at).
          to be_within(1.second).of(bulletin.published_at)
        expect(subject.series).to be_nil
        expect(subject.speaker).to eq "MCAC"
        expect(subject.name).to eq bulletin.description
        expect(bulletin.reload.sermon).to eq subject
      end
    end

    context "when the bulletin service order mentions Pastor Ryan" do
      shared_examples_for "a sermon by expected speaker" do
        it "migrates a sermon from the bulletin" do
          speaker_values.each do |s|
            create(:bulletin,
                   audio_url: "http://nba.com/audio.mp3",
                   service_order: "what #{s} what",
                   description: "random desc")
            MigrateSermons.new.process
            expect(Sermon.last.speaker).to eq expected_speaker
          end
        end
      end

      context "when it contains Pastor Ryan's name" do
        let(:speaker_values) { %w{rYan LEE Ryan Lee lee ryan} }
        let(:expected_speaker) { "Pastor Ryan Lee" }
        it_behaves_like "a sermon by expected speaker"
      end

      context "when it contains Pastor Marshall's name" do
        let(:speaker_values) { %w{Marshall Davis marshall} }
        let(:expected_speaker) { "Rev. Marshall Davis" }
        it_behaves_like "a sermon by expected speaker"
      end

      context "when it contains Rev. Chan's name" do
        let(:speaker_values) { %w{Thomas Chan thomas chan} }
        let(:expected_speaker) { "Rev. Thomas Chan" }
        it_behaves_like "a sermon by expected speaker"
      end
    end
  end
end
