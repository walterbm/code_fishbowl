defmodule CodeFishbowl.BowlView do
  use CodeFishbowl.Web, :view

  @langs Application.get_env(:code_fishbowl, :languages)

  def langs, do: @langs

end
