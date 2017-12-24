defmodule ExAws.Polly do
  @moduledoc """
  Documentation for ExAws.Polly.
  """

  def describe_voices do
    request(:get, :describe_voices, path: "/v1/voices", parser: &ExAws.Polly.Parsers.parse/2 )
  end

  def synthesize_speech(text) do
    body = %{
      "OutputFormat" => "mp3",
      "Text" => text,
      "VoiceId" => "Joanna"
    }

    request(:post, :synthesize_speech, body: body, path: "/v1/speech")
  end

  defp request(http_method, action, opts \\ []) do
    path = Keyword.get(opts, :path, "/")
    body = Keyword.get(opts, :body, "")
    parser = Keyword.get(opts, :parser, nil)

    %ExAws.Operation.RestQuery{
      http_method: http_method,
      action: action,
      path: path,
      body: body,
      parser: parser,
      service: :polly
    }
  end
end
