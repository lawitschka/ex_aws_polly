defmodule ExAws.Polly.Parsers do
  def parse({:ok, %{body: json}}, :describe_voices) do
    Poison.decode(json)
  end

  def parse(response, _action) do
    response
  end
end
