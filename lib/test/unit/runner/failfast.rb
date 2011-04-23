require 'test/unit'
require 'test/unit/ui/console/testrunner'

class FailFastRunner < Test::Unit::UI::Console::TestRunner
  def initialize(suite, options={})
    @finished = []
    @bar_length = 50
    @status = Hash.new { |h, k| h[k] = 0 }
    @bar = (0...@bar_length).map { |i| " " }
    super
  end

  def add_fault(fault)
    @faults << fault
    output "\r" + (" " * 80) + "\r"
    output("%3d) %s" % [@faults.length, fault.long_display])
    output("--")
    nl

    @already_outputted = true
    add_progress @finished.size, char_fault(fault), 1

    @status[fault.single_character_display] += 1
    output_progress
  end

  def finished(elapsed_time)
    nl
    output("Finished in #{elapsed_time} seconds.")
    nl
    output(@result)
  end

  def test_finished(name)
    @finished << name
    add_progress @finished.size, char_success
    super
  end

  def char_fault(fault)
    char  = fault.single_character_display
    color = fault_color(fault)
    reset = @reset_color.escape_sequence
    char  = "%s%s%s" % [ color.escape_sequence, char, reset ]
  end

  def char_success
    "\033[0;43m.\033[0m"
  end

  # Adds a char to the progress bar.
  def add_progress(i, char, priority=0)
    first_index = (i-1) * @bar_length / @suite.size
    last_index = i * @bar_length / @suite.size
    # Don't override E's!

    (first_index..last_index).each do |index|
      @bar[index] = char  unless @bar[index] != " " && priority == 0
    end
  end

  def output_started
    output("Started")
    nl
  end

  def status_indicator
    status = @status.map { |char, i| "#{i}#{char}" }.join(" ")
    status = " \033[0;31m[#{status}]\033[0m" unless status.empty?
    status
  end

  def output_progress(mark=nil, color=nil)
    reset = @reset_color.escape_sequence
    perc = [100, @finished.size * 100 / @suite.size].min

    output_status "%3i%% |%s| %3i of %i%s" % [ perc, @bar.join(""), @finished.size, @suite.size, status_indicator ]
  end

  def output_status(str)
    print "\r#{str}"
  end
end

Test::Unit::AutoRunner::RUNNERS[:failfast] = proc { |r| FailFastRunner }
