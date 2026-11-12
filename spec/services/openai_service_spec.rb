require "rails_helper"

RSpec.describe OpenaiService do
  let(:service) { OpenaiService.new }
  let(:response) { double("OpenAI Response", output_text: "こんにちは！") }
  let(:responses) { double("Responses") }
  let(:client) { double("OpenAI Client", responses: responses) }

  before do
    allow(OpenAI::Client).to receive(:new).and_return(client)
  end

  describe "#generate" do
    it "OpenAI APIから取得した文章を返すこと" do
      allow(responses).to receive(:create).and_return(response)

      expect(service.generate).to eq("こんにちは！")
    end

    it "APIエラーが発生した場合にnilを返すこと" do
      error = OpenAI::Errors::APIError.new(
        url: "https://api.openai.com/v1/responses",
        message: "APIエラーが発生しました"
        )

      allow(responses).to receive(:create).and_raise(error)

      expect(service.generate).to be_nil
    end
  end
end