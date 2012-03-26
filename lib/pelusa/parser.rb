module Pelusa
  class Parser

    # Public - Initializes a parser based on the current environment
    def self.init!
      if Parser.rubinius?
        Parser.setup_rubinius_parser!
      elsif Parser.standalone_parser?
        Parser.setup_standalone_parser!
      else
        raise NoParserError, "You must run Rubinius or install the Melbourne standalone parser."
      end
    end

    class << self

      protected

      # Internal - Indicates whether or not Rubinius is being used.
      #
      # Returns A boolean representing if Rubinius is being used. 
      def rubinius?
        RUBY_ENGINE == "rbx" && !defined?(Rubinius).nil?
      end

      # Internal - Indiciates whether or not Melbourne parser is separately available.
      #
      # Returns A boolean representing the availability of the Melbourne parser.
      def standalone_parser?
        require 'melbourne'
        true
      rescue LoadError
        false
      end

      # Internal - Ensures that Rubinius is running in correct mode
      def setup_rubinius_parser!
        unless Rubinius.ruby19?
          raise NoRuby19Error, 
          "Pelusa needs Rubinius to run in 1.9 mode.\n"\
          "Please either `export RBXOPT=-X19` before running it or compile Rubinius with\n"\
          "1.9 support enabled by default."
        end
      end

      # Internal - Adds in methods that the Melbourne standalone parser will expect in the Rubinius module
      def setup_standalone_parser!
        Rubinius.send(:extend, RubiniusShim)
      end

      # The Melbourne parser expects these methods to be defined in the Rubinius module
      module RubiniusShim
        def ruby19?
          RUBY_VERSION.to_f == 1.9
        end
        def ruby18?
          RUBY_VERSION.to_f == 1.8
        end
      end
    end

    class NoParserError < StandardError; end
    class NoRuby19Error < StandardError; end
  end
end
