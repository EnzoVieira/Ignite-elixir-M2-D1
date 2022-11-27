defmodule GenReport do
  alias GenReport.Parser

  @workers [
    "cleiton",
    "daniele",
    "danilo",
    "diego",
    "giuliano",
    "jakeliny",
    "joseph",
    "mayk",
    "rafael",
    "vinicius"
  ]
  @months [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]
  @years [
    2016,
    2017,
    2018,
    2019,
    2020
  ]

  def build, do: {:error, "Insira o nome de um arquivo"}

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), &sum_value/2)
  end

  defp sum_value([name, hours, _day, month, year], %{
         "all_hours" => all_hours,
         "hours_per_month" => hours_per_month,
         "hours_per_year" => hours_per_year
       }) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)

    hours_per_month =
      Map.put(
        hours_per_month,
        name,
        Map.put(hours_per_month[name], month, hours_per_month[name][month] + hours)
      )

    hours_per_year =
      Map.put(
        hours_per_year,
        name,
        Map.put(hours_per_year[name], year, hours_per_year[name][year] + hours)
      )

    build_report_map(all_hours, hours_per_month, hours_per_year)
  end

  defp report_acc do
    all_hours = Map.new(@workers, fn worker -> {worker, 0} end)

    hours_per_month =
      Map.new(@workers, fn worker ->
        {worker, Map.new(@months, fn month -> {month, 0} end)}
      end)

    hours_per_year =
      Map.new(@workers, fn worker ->
        {worker, Map.new(@years, fn year -> {year, 0} end)}
      end)

    build_report_map(all_hours, hours_per_month, hours_per_year)
  end

  defp build_report_map(all_hours, hours_per_month, hours_per_year),
    do: %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
end
