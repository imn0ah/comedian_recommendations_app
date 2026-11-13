require "rails_helper"

RSpec.describe YoutubeService do
    let(:service) { YoutubeService.new }

    let(:response) do
        Net::HTTPOK.new("1.1", "200", "OK")
    end

    describe "search" do
        it "Youtube APIから動画の検索結果w取得できること" do
            allow(Net::HTTP).to receive(:get_response).and_return(response)
            allow(response).to receive(:body).and_return('{"items":[]}')

            expect(service.search).to eq({ "items" => [] })
        end

        it "YouTube APIからエラーが返された場合はnilを返すこと" do
           error_response = Net::HTTPForbidden.new("1.1", "403", "Forbidden")
           allow(Net::HTTP).to receive(:get_response).and_return(error_response)
           expect(service.search).to be_nil
        end
    end
end
