# frozen_string_literal: true

module OutputSuppressor
  def suppress_output
    orig_stdout = $stdout
    $stdout = File.open(File::NULL, "w")
    yield
  ensure
    $stdout = orig_stdout
  end
end
