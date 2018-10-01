require "lucky_cli"
require "colorize"

class Build::Release < LuckyCli::Task
  COMMAND = "crystal"
  ARGS = ["build", "--release", "src/server.cr"]

  banner "Build a binary using '#{COMMAND} #{ARGS.join(" ")}'"

  def call
    puts "running '#{COMMAND} #{ARGS.join(" ")}'"
    output = IO::Memory.new
    error = IO::Memory.new
    result = Process.run(COMMAND, args: ARGS, output: output, error: error)
    if result.success?
      puts output.to_s.empty? ? "Successfully built binary" : output.to_s
    else 
      puts error.to_s.empty? ? "Failed to build binary" : error.to_s
    end
  end
end
