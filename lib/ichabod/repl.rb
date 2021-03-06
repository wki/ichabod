require 'readline'

module Ichabod
  class Repl
    Prompt = 'js> '
    AwaitingInput = '?> '
    Result = '=> '
    HistoryFile = File.join(File.expand_path('~'), '.ichabod_history')

    def self.start(dom = nil)
      load_history
      @parser = Ichabod::Runtime.new(:dom => dom)

      loop do
        input = Readline.readline(Prompt)
        quit if input.nil?

        begin
          puts Result + @parser.eval(input).inspect.to_s
        rescue => e
          save_history
          raise e
        else
          Readline::HISTORY.push(input)
        end
      end
    end

    def self.load_history
      return unless File.exists? HistoryFile
      File.readlines(HistoryFile).each do |line|
        Readline::HISTORY.push line.chomp
      end
    end

    def self.save_history
      File.open(HistoryFile, 'w') do |f|
        f.puts Readline::HISTORY.to_a.join("\n")
      end
    end

    def self.quit
      save_history
      exit
    end
  end
end