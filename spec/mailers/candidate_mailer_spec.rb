require "rails_helper"

RSpec.describe CandidateMailer, type: :mailer do
  describe "#entry_test_invitation" do
    let(:entry_test) { FactoryBot.create(:entry_test) }
    let(:candidate) { FactoryBot.create(:candidate, :invited_to_test, entry_test: entry_test) }
    let(:mail) { CandidateMailer.entry_test_invitation(candidate, entry_test) }

    it "renders the headers" do
      expect(mail.subject).to end_with("pozvánka na vstupní test")
      expect(mail.to).to eq([candidate.user.mail])
    end

    it "renders the time of the test" do
      expect(mail.body.encoded).to match(entry_test.time.to_date.strftime('%d. %m. %Y'))
      expect(mail.body.encoded).to match(entry_test.time.to_time.strftime('%H:%M'))
    end
  end

  pending '#entry_test_update - add examples'
end
