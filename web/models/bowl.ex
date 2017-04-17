defmodule CodeFishbowl.Bowl do
  defstruct [:body, :lang, :row, :column]

  def default do
    %CodeFishbowl.Bowl{
      body: "var test = 42;",
      lang: "javascript",
      row: "0",
      column: "0"
    }
  end
end
