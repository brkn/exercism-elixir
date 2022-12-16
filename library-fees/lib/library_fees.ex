defmodule LibraryFees do
  def datetime_from_string(string), do: NaiveDateTime.from_iso8601!(string)

  def before_noon?(datetime) do
    compared = Time.compare(~T[12:00:00.00Z], datetime)

    case compared do
      :gt -> true
      _ -> false
    end
  end

  def return_date(checkout_datetime) do
    days_to_add =
      case before_noon?(checkout_datetime) do
        true -> 28
        false -> 29
      end

    NaiveDateTime.to_date(checkout_datetime) |> Date.add(days_to_add)
  end

  def days_late(planned_return_date, actual_return_datetime) do
    diff = Date.diff(actual_return_datetime, planned_return_date)

    case diff < 0 do
      true -> 0
      _ -> diff
    end
  end

  def monday?(datetime), do: Date.day_of_week(datetime) == 1

  def calculate_late_fee(checkout, return, rate) do
    actual_returned_date = datetime_from_string(return)

    days_late = checkout
      |> datetime_from_string
      |> return_date
      |> days_late(actual_returned_date)

    case monday?(actual_returned_date) do
      true -> Float.floor(days_late * rate * 0.5)
      false -> days_late * rate
    end
  end
end
