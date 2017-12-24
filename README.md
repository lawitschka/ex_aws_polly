# ExAws.Polly

AWS Polly service module for https://github.com/ex-aws/ex_aws

## Installation

The package can be installed by adding `ex_aws_polly` to your list of dependencies in `mix.exs`
along with `:ex_aws` and your preferred JSON codec / http client

```elixir
def deps do
  [
    {:ex_aws, "~> 2.0"},
    {:ex_aws_polly, "~> 0.2.0"},
    {:poison, "~> 3.0"},
    {:hackney, "~> 1.9"},
  ]
end
```

## Usage

Turn text to speech
```elixir
{:ok, %{body: audio_data}} =
  "Hello world."
  |> ExAws.Polly.synthesize_speech()
  |> ExAws.request()

{:ok, file} = File.read("hello.mp3", [:write])
IO.binwrite(file, audio_data)
File.close(file)
```

Get a list of available voices
```elixir
ExAws.Polly.describe_voices() |> ExAws.request()
```

## Todo

[] add documentation
[] add test coverage
[] support Lexicon actions (ListLexicons, GetLexicon, PutLexicon, DeleteLexicon)

## License

The MIT License (MIT)

Copyright (c) 2017 Joseph An

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
