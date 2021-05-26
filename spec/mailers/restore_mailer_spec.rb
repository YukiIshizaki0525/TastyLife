require "rails_helper"

RSpec.describe RestoreMailer, type: :mailer do
  describe "send_when_restore" do
    let(:mail) { RestoreMailer.send_when_restore }

    it "renders the headers" do
      expect(mail.subject).to eq("Send when restore")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
