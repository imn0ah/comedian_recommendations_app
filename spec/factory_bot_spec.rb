require "rails_helper"

RSpec.describe "FactoryBot configuration" do
    it "FactoryBotのbuildメソッドが使える" do
        expect(respond_to?(:build)).to eq(true)
    end
end
