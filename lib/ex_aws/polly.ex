defmodule ExAws.Polly do
  @moduledoc """
  Documentation for ExAws.Polly.
  """

  def synthesize_speech(text) do
    request(%{
      "OutputFormat" => "mp3",
      "Text" => text,
      "VoiceId" => "Joanna"
    })
  end

  defp request(params) do
    ExAws.Operation.JSON.new(:polly, %{
      path: "/v1/speech",
      data: params,
      headers: [
        {"content-type", "application/json"},
      ]
    })
  end
end
