defmodule Maru.Builder.Versioning.Path do
  @moduledoc """
  Adapter for path versioning module.
  """

  use Maru.Builder.Versioning

  @doc false
  def plug(_opts), do: []

  @doc false
  def path_for_params(path, version) do
    Enum.map(path, fn
      {:version} -> version
      x          -> x
    end)
  end

  @doc false
  def conn_for_match(method, version, path) do
    quote do
      %Plug.Conn{
        method: unquote(method),
        path_info: unquote(path_for_match(path, version)),
      }
    end
  end

  @doc false
  defp path_for_match(path, version) do
    Enum.map(path, fn
      {:version}        -> version
      x when is_atom(x) -> Macro.var(:_, nil)
      x                 -> x
    end)
  end

end
