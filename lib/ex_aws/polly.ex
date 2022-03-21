defmodule ExAws.Polly do
  @moduledoc """
  Service module for AWS Polly for speech synthesis.
  """

  @default_output_format "mp3"
  @default_voice_id "Joanna"

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

  @type synthesize_speech_options :: [
          output_format: String.t(),
          voice_id: String.t(),
          engine: String.t(),
          language_code: String.t(),
          lexicon_names: [String.t()],
          sample_rate: String.t(),
          text_type: String.t()
        ]

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
  @spec synthesize_speech(String.t(), synthesize_speech_options) :: ExAws.Operation.RestQuery.t()
  def synthesize_speech(text, opts \\ []) do
    {output_format, opts} = Keyword.pop(opts, :output_format, @default_output_format)
    {voice_id, opts} = Keyword.pop(opts, :voice_id, @default_voice_id)

    required_params = %{
      "Text" => text,
      "OutputFormat" => output_format,
      "VoiceId" => voice_id
    }

    optional_params = Enum.map(opts, fn {k, v} -> {format_opt(k), v} end) |> Enum.into(%{})

    body = Map.merge(required_params, optional_params)

    request(:post, :synthesize_speech, body: body, path: "/v1/speech")
  end

  @type start_speech_synthesis_task_options :: [
          output_format: String.t(),
          voice_id: String.t(),
          engine: String.t(),
          language_code: String.t(),
          lexicon_names: [String.t()],
          output_s3_key_prefix: String.t(),
          sample_rate: String.t(),
          sns_topic_arn: String.t(),
          text_type: String.t()
        ]

  @doc """
  Allows the creation of an asynchronous synthesis task, by starting a new SpeechSynthesisTask.
  https://docs.aws.amazon.com/polly/latest/dg/API_StartSpeechSynthesisTask.html

  ## Options
    * `:output_format` - The format in which the returned output will be encoded (mp3, ogg_vorbis, or pcm). Default is mp3.
    * `:voice_id` - Voice ID to use for the synthesis. You can get a list of available voice IDs by calling `ExAws.Polly.describe_voices`. Default is "Joanna".
    * `:engine` - Specifies the engine (`standard` or `neural`) to use when processing input text for speech synthesis.
    * `:language_code` - Optional language code for the Synthesize Speech request. This is only necessary if using a bilingual voice, such as Aditi, which can be used for either Indian English (en-IN) or Hindi (hi-IN).
    * `:lexicon_names` - List of one or more pronunciation lexicon names you want the service to apply during synthesis.
    * `:output_s3_key_prefix` - The Amazon S3 key prefix for the output speech file.
    * `:sample_rate` - The audio frequency specified in Hz.  Valid values for mp3 and ogg_vorbis are "8000", "16000", and "22050". Valid values for pcm are "8000" and "16000". Default is "16000".
    * `:sns_topic_arn` - ARN for the SNS topic optionally used for providing status notification for a speech synthesis task.
    * `:text_type` - Specifies whether the input text is plain text or SSML. Default is plain text.

  ## Example

      iex> ExAws.Polly.start_speech_synthesis_task("hello world", "polly-bucket") |> ExAws.request()
      {:ok,
       %{
         body:
           <<123, 34, 83, 121, 110, 116, 104, 101, 115, 105, 115, 84, 97, 115, 107, 34, 58, 123, 34, 67,
             114, 101, 97, 116, 105, 111, 110, 84, 105, 109, 101, 34, 58, 49, 46, 54, 52, 55, 51, 52,
             50, 56, 49, 56, 52, 48, 52, 69, 57, 44>>,
         headers: [
           {"x-amzn-RequestId", "8c730aaa-530e-4b46-bb34-b1827d1a7eac"},
           {"Content-Type", "application/json"},
           {"Content-Length", "463"},
           {"Date", "Tue, 15 Mar 2022 11:13:38 GMT"}
         ],
         status_code: 200
       }}
  """
  @spec start_speech_synthesis_task(String.t(), String.t(), start_speech_synthesis_task_options) ::
          ExAws.Operation.RestQuery.t()
  def start_speech_synthesis_task(text, output_s3_bucket_name, opts \\ []) do
    {output_format, opts} = Keyword.pop(opts, :output_format, @default_output_format)
    {voice_id, opts} = Keyword.pop(opts, :voice_id, @default_voice_id)

    required_params = %{
      "Text" => text,
      "OutputFormat" => output_format,
      "VoiceId" => voice_id,
      "OutputS3BucketName" => output_s3_bucket_name
    }

    optional_params = Enum.map(opts, fn {k, v} -> {format_opt(k), v} end) |> Enum.into(%{})

    body = Map.merge(required_params, optional_params)

    request(:post, :start_speech_synthesis_task, body: body, path: "/v1/synthesisTasks")
  end

  @doc """
  Retrieves a specific SpeechSynthesisTask object based on its TaskID.
  This object contains information about the given speech synthesis task, including the status of the task, and a link to the S3 bucket containing the output of the task.
  https://docs.aws.amazon.com/polly/latest/dg/API_GetSpeechSynthesisTask.html

  ## Example

      iex> ExAws.Polly.get_speech_synthesis_task(task_id) |> ExAws.request()
      {:ok,
       %{
         body:
           <<123, 34, 83, 121, 110, 116, 104, 101, 115, 105, 115, 84, 97, 115, 107, 34, 58, 123, 34, 67,
             114, 101, 97, 116, 105, 111, 110, 84, 105, 109, 101, 34, 58, 49, 46, 54, 52, 55, 51, 52,
             50, 56, 49, 56, 52, 48, 52, 69, 57, 44, ...>>,
         headers: [
           {"x-amzn-RequestId", "8c730aaa-530e-4b46-bb34-b1827d1a7eac"},
           {"Content-Type", "application/json"},
           {"Content-Length", "463"},
           {"Date", "Tue, 15 Mar 2022 11:13:38 GMT"}
         ],
         status_code: 200
       }}
  """
  @spec get_speech_synthesis_task(String.t()) :: ExAws.Operation.RestQuery.t()
  def get_speech_synthesis_task(id) do
    request(:get, :get_speech_synthesis_task, path: "/v1/synthesisTasks/" <> id)
  end

  defp format_opt(:engine), do: "Engine"
  defp format_opt(:language_code), do: "LanguageCode"
  defp format_opt(:lexicon_names), do: "LexiconNames"
  defp format_opt(:output_s3_key_prefix), do: "OutputS3KeyPrefix"
  defp format_opt(:sample_rate), do: "SampleRate"
  defp format_opt(:sns_topic_arn), do: "SnsTopicArn"
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
