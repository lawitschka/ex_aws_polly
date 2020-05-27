defmodule ExAws.Polly do
  @moduledoc """
  Service module for AWS Polly for speech synthesis.
  """

  @doc """
  Returns the list of voices that are available for use when requesting speech synthesis.
  Each voice speaks a specified language, is either male or female, and is identified by an ID, which is the ASCII version of the voice name.
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
    * `:engine` - Specifies the engine (`standard` or `neural`) to use when processing input text for speech synthesis.
    * `:language_code` - Optional language code for the Synthesize Speech request. This is only necessary if using a bilingual voice, such as Aditi, which can be used for either Indian English (en-IN) or Hindi (hi-IN).
    * `:lexicon_names` - List of one or more pronunciation lexicon names you want the service to apply during synthesis.
    * `:sample_rate` - The audio frequency specified in Hz.  Valid values for mp3 and ogg_vorbis are "8000", "16000", and "22050". Valid values for pcm are "8000" and "16000". Default is "16000".
    * `:text_type` - Specifies whether the input text is plain text or SSML. Default is plain text.

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
    {output_format, opts} = Keyword.pop(opts, :output_format, "mp3")
    {voice_id, opts} = Keyword.pop(opts, :voice_id, "Joanna")

    required_params = %{
      "Text" => text,
      "OutputFormat" => output_format,
      "VoiceId" => voice_id
    }

    optional_params = Enum.map(opts, fn {k, v} -> {format_opt(k), v} end) |> Enum.into(%{})

    body = Map.merge(required_params, optional_params)

    request(:post, :synthesize_speech, body: body, path: "/v1/speech")
  end

  defp format_opt(:engine), do: "Engine"
  defp format_opt(:language_code), do: "LanguageCode"
  defp format_opt(:lexicon_names), do: "LexiconNames"
  defp format_opt(:sample_rate), do: "SampleRate"
  defp format_opt(:text_type), do: "TextType"

  defp request(http_method, action, opts) do
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
