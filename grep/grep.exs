defmodule Grep do

  @spec grep(String.t, [String.t], [String.t]) :: String.t
  def grep(pattern, flags, files) when length(files) == 1 do
    stream = File.stream!(hd(files))
    results = case Enum.sort(flags) do
      ["-i", "-n", "-x"] -> stream 
        |> Stream.with_index 
        |> Stream.filter(fn {line, _} -> String.downcase(pattern) <> "\n" == String.downcase(line) end) 
        |> Stream.map(fn {line, i} -> "#{i + 1}:#{line}" end)
      ["-i", "-n"] -> stream
        |> Stream.with_index
        |> Stream.filter(fn {line, _} -> String.contains?(String.downcase(line), String.downcase(pattern)) end)
      ["-i", "-x"] -> stream
        |> Stream.filter(&(String.downcase(&1) == String.downcase(pattern) <> "\n"))
      ["-n", "-x"] -> stream
        |> Stream.with_index
        |> Stream.filter(fn {line, _} -> line == pattern <> "\n" end)
        |> Stream.map(fn {line, i} -> "#{i + 1}:#{line}" end)
      ["-n"] -> stream
        |> Stream.with_index
        |> Stream.filter(fn {line, _} -> String.contains?(line, pattern) end)
        |> Stream.map(fn {line, i} -> "#{i + 1}:#{line}" end)
      ["-i"] -> stream
        |> Stream.filter(&(String.contains?(String.downcase(&1), String.downcase(pattern))))
      ["-x"] -> stream
        |> Stream.filter(&(&1 == pattern <> "\n"))
      ["-l"] -> if Enum.any?(stream, &(String.contains?(&1, pattern))), do: [hd(files) <> "\n"], else: [""]
      [] -> stream
        |> Stream.filter(&(String.contains?(&1, pattern)))
      ["-v"] -> stream
        |> Stream.reject(&(String.contains?(&1, pattern)))
      _ -> [""]
    end
    Enum.join(results, "")
  end
  
  def grep(pattern, flags, files) do
    _grep(pattern, flags, files, "")
  end
  
  defp _grep(_, _, [], acc), do: acc
  defp _grep(pattern, flags, [h|t], acc) do
    unless "-l" in flags do
      current = String.split(grep(pattern, flags, [h]), "\n", trim: true)
      |> Stream.map(&("#{h}:#{&1}\n"))
      |> Enum.join("")
      _grep(pattern, flags, t, acc <> current)
    else
      _grep(pattern, flags, t, acc <> grep(pattern, ["-l"], [h]))
    end
  end
end
