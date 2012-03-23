module Pelusa
  class Parser

    # Public - Initializes a parser based on the current environment
    def self.init!
      if Parser.rubinius?
        # nothing to do!
      elsif Parser.melbourne?
        Parser.shim_melbourne!
      else
        raise NoParserError, "You must run Rubinius or install the Melbourne parser."
      end
    end

    class << self

      protected

      # Internal - Indicates whether or not Rubinius is being used.
      #
      # Returns A boolean representing if Rubinius is being used. 
      def rubinius?
        !defined?(Rubinius).nil?
      end

      # Internal - Indiciates whether or not Melbourne parser is separately available.
      #
      # Returns A boolean representing the availability of the Melbourne parser.
      def melbourne?
        require 'melbourne'
        true
      rescue LoadError => e
        false
      end

      # Internal - Adds in methods that the Melbourne parser will expect in the Rubinius module
      def shim_melbourne!
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
  end
end
