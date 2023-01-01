defmodule Newsletter do
  def read_emails(path), do: path |> File.read! |> String.split("\n", trim: true)

  def open_log(path), do: path |> File.open!([:write])

  def log_sent_email(pid, email), do: IO.puts(pid, email)

  def close_log(pid), do: File.close(pid)

  def send_newsletter(emails_path, log_path, send_fun) do
    log_pid = open_log(log_path)

    emails_path
    |> read_emails()
    |> Stream.map(fn email -> {send_fun.(email), email} end)
    |> Stream.each(fn
      {:ok, email} -> log_sent_email(log_pid, email)
      _ -> nil
    end)
    |> Stream.run()

    close_log log_pid
  end
end
