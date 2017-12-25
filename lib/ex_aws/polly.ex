defmodule ExAws.Polly do
  @moduledoc """
  Service module for AWS Polly for speech synthesis.
  """

  @doc """
  Returns the list of voices that are available for use when requesting speech synthesis. Each voice speaks a specified language, is either male or female, and is identified by an ID, which is the ASCII version of the voice name.
  http://docs.aws.amazon.com/polly/latest/dg/API_DescribeVoices.html

  ## Example

      iex> ExAws.Polly.describe_voices() |> ExAws.request()
      {:ok,
       %{"NextToken" => nil,
         "Voices" => [%{"Gender" => "Female", "Id" => "Joanna",
            "LanguageCode" => "en-US", "LanguageName" => "US English",
            "Name" => "Joanna"},
          %{"Gender" => "Male", "Id" => "Takumi",
            "LanguageCode" => "ja-JP", "LanguageName" => "Japanese",
            "Name" => "Takumi"}, , %{...}, ...]}}

  """
  def describe_voices do
    request(:get, :describe_voices, path: "/v1/voices")
  end

  @doc """
  Returns synthesized speech binary from given text.
  http://docs.aws.amazon.com/polly/latest/dg/API_SynthesizeSpeech.html
  ## Options
    * `:output_format` - The format in which the returned output will be encoded (mp3, ogg_vorbis, or pcm). Default is mp3.
    * `:voice_id` - Voice ID to use for the synthesis. You can get a list of available voice IDs by calling `ExAws.Polly.describe_voices`. Default is "Joanna".
    * `:sample_rate` - The audio frequency specified in Hz.  Valid values for mp3 and ogg_vorbis are "8000", "16000", and "22050". Valid values for pcm are "8000" and "16000". Default is "16000".
  
  ## Example

      iex> ExAws.Polly.synthesize_speech("hello world") |> ExAws.request()
      {:ok,
       %{body: <<73, 68, 51, 4, 0, 0, 0, 0, 0, 35, 84, 83, 83, 69, 0, 0, 0,
           15, 0, 0, 3, 76, 97, 118, 102, 53, 55, 46, 55, 49, 46, 49, 48,
           48, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 243, 88, ...>>,
         headers: [{"x-amzn-RequestId",
           "3e7dbbf6-e912-11e7-a27d-e308ce5e5bf6"},
          {"x-amzn-RequestCharacters", "5"},
          {"Content-Type", "audio/mpeg"}, {"Transfer-Encoding", "chunked"},
          {"Date", "Mon, 25 Dec 2017 01:23:42 GMT"}], status_code: 200}}
  """
  def synthesize_speech(text, opts \\ []) do
    output_format = Keyword.get(opts, :output_format, "mp3")
    voice_id = Keyword.get(opts, :voice_id, "Joanna")
    sample_rate = Keyword.get(opts, :sample_rate, "16000")

    body = %{
      "Text" => text,
      "OutputFormat" => output_format,
      "VoiceId" => voice_id,
      "SampleRate" => sample_rate
    }

    request(:post, :synthesize_speech, body: body, path: "/v1/speech")
  end

  defp request(http_method, action, opts \\ []) do
    path = Keyword.get(opts, :path, "/")
    body = Keyword.get(opts, :body, "")

    %ExAws.Operation.RestQuery{
      http_method: http_method,
      action: action,
      path: path,
      body: body,
      parser: &ExAws.Polly.Parsers.parse/2,
      service: :polly
    }
  end
end
