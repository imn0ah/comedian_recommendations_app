class OpenaiService
  def initialize
    @client = OpenAI::Client.new
  end

  def generate
    response = @client.responses.create(
      model: "gpt-4.1-mini",
      input: "こんにちは。短く挨拶してください。"
    )

    response.output_text
  rescue OpenAI::Errors::APIError => e
    Rails.logger.error("OpenAI APIエラー: #{e.class}")
    nil
  end
end
