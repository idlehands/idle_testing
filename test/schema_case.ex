defmodule IdleTesting.SchemaCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias IdleTesting.Factory
      require Ecto.Changeset
      import IdleTesting.SchemaCase
    end
  end

  def fields_for(%schema_name{}), do: schema_name.__schema__(:fields)
  def fields_for(%{} = map), do: Map.keys(map)
  def fields_for(schema_name), do: schema_name.__schema__(:fields)

  def assert_values_for(all_the_things) do
    expected = Keyword.fetch!(all_the_things, :expected)
    actual = Keyword.fetch!(all_the_things, :actual)
    fields = Keyword.fetch!(all_the_things, :fields)

    opts = all_the_things[:opts] || []

    expected = update_keys(expected)
    actual = update_keys(actual)
    fields = maybe_convert_fields_to_atoms(fields)

    for field <- fields do
      with {{:ok, expected}, _} <- {Map.has_key?(expected, field), :expected},
           {{:ok, actual}, _} <- {Map.has_key?(actual, field), :actual} do
        expected =
          maybe_convert_datetime_to_string(Map.fetch(expected, field), opts[:convert_dates])

        actual = maybe_convert_datetime_to_string(Map.fetch(actual, field), opts[:convert_dates])

        assert(
          expected == actual,
          "Values did not match for field: #{field}\nexpected: #{inspect(expected)}\nactual: #{
            inspect(actual)
          }"
        )
      else
        {:error, type} -> flunk("Key for field: #{field} didn't exist in #{type}")
      end
    end
  end

  defp maybe_convert_fields_to_atoms(fields) do
    Enum.map(
      fields,
      fn
        field when is_binary(field) -> String.to_atom(field)
        field when is_atom(field) -> field
      end
    )
  end

  defp maybe_convert_datetime_to_string(%DateTime{} = datetime, true = _convert_dates) do
    DateTime.to_iso8601(datetime)
  end

  defp maybe_convert_datetime_to_string(datetime, _) do
    datetime
  end

  defp update_keys({map, :string_keys}) when is_map(map) do
    for {key, value} <- map, into: %{}, do: {String.to_atom(key), value}
  end

  defp update_keys({map, :atom_keys}) do
    map
  end

  defp update_keys(map) do
    map
  end

  def errors_on(struct, data) do
    struct.__struct__.changeset(struct, data)
    |> errors_on()
  end

  def errors_on(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {_, opts} ->
      Keyword.pop(opts, :validation)
    end)
    |> Enum.flat_map(fn {key, errors} ->
      for info <- errors, do: validation_info(key, info)
    end)
  end

  def without_opts(errors) do
    Enum.map(errors, fn error ->
      case error do
        {key, type} -> {key, type}
        {key, type, _opts} -> {key, type}
      end
    end)
  end

  defp validation_info(key, {type, []}), do: {key, type}

  defp validation_info(key, {type, opts}) when is_list(opts) do
    opts = opts |> Keyword.drop([:count]) |> Enum.sort()
    {key, type, opts}
  end

  defp validation_info(key, errors) when is_map(errors) do
    {key,
     Enum.flat_map(errors, fn {key, errors} ->
       for info <- errors, do: validation_info(key, info)
     end)}
  end

  defp validation_info(key, {type, opts}) when is_map(opts) do
    new_opts = Map.to_list(opts)
    validation_info(key, {type, new_opts})
  end
end
