require "lucky_cli"
require "./file"
require "./log"

class Enigma::Smudge < LuckyCli::Task
  include Log

  banner "Task used for git smudge on checkout (decrypt)"

  def call
    log "------ Attempting to smudge with args: #{ARGV.inspect}"
    contents = STDIN.gets_to_end.to_s.chomp
    log "------ Smudge/decrypting: #{contents}"
    STDOUT.puts Enigma::File.new(contents).decrypt
  end
end