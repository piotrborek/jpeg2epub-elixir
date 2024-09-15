defmodule Images do
  defmodule ParseState do
    use TypedStruct

    typedstruct do
      field :previous, boolean()
      field :current, [String.t()]
      field :output, [String.t() | integer()]
    end

    @spec init(:int | :char, String.t()) :: ParseState.t()
    def init(type, char), do:
      %Images.ParseState{
        previous: type,
        current: [char],
        output: []
      }

    @spec update_current(ParseState.t(), String.t()) :: ParseState.t()
    def update_current(%ParseState{} = parseState, char), do:
      %ParseState{ parseState |
        current: [char | parseState.current]
      }

    @spec update_output(ParseState.t(), :int | :char, String.t()) :: ParseState.t()
    def update_output(%ParseState{} = parseState, type, char), do:
      %ParseState{ parseState |
        previous: type,
        current: [char],
        output: [to_int_or_string(parseState) | parseState.output]
      }

    @spec to_list(ParseState.t()) :: [String.t | integer()]
    def to_list(%ParseState{} = parseState), do:
      [to_int_or_string(parseState) | parseState.output]

    @spec to_int_or_string(ParseState.t()) :: String.t() | integer()
    defp to_int_or_string(%ParseState{} = parseState) do
      str = parseState.current |> Enum.reverse() |> List.to_string()

      case parseState.previous do
        :int -> str |> Integer.parse() |> then(fn { val, _ } -> val end)
        :char -> str
        _ -> raise "Images.to_int_or_string/2: Should never happen."
      end
    end
  end

  @spec list_images(AppConfig.t()) :: [binary()]
  def list_images(%AppConfig{} = config) do
    if config.cli.from_directory do
      Path.wildcard(config.cli.input <> "/**/*.{jpg,jpeg,png}")
    else
      Path.wildcard(config.directories.unzip <> "/**/*.{jpg,jpeg,png}")
    end
  end

  @spec sort_images([String.t()]) :: [String.t()]
  def sort_images(list) do
    list
      |> Enum.map(fn str -> [str, parse_string(Path.basename(str))] end)
      |> Enum.sort(fn [_, a], [_, b] -> a < b end)
      |> Enum.map(fn [head | _tail] -> head end)
  end

  def parse_string(text) do
    text
      |> String.graphemes()
      |> Enum.reduce(%ParseState{ previous: :none }, fn char, acc ->
           type = typeof(char)
           case acc.previous do
             :none ->
               ParseState.init(type, char)

             :int when type == :int ->
               ParseState.update_current(acc, char)

             :int when type == :char ->
               ParseState.update_output(acc, type, char)

             :char when type == :int ->
               ParseState.update_output(acc, type, char)

             :char when type == :char ->
               ParseState.update_current(acc, char)

             _ -> raise "Images.parse_string/1: Should never happen."
           end
         end)
      |> then(&ParseState.to_list/1)
      |> Enum.reverse()
  end

  @spec typeof(String.t()) :: :int | :char
  defp typeof(char) do
    if char >= "0" and char <= "9", do: :int, else: :char
  end
end
