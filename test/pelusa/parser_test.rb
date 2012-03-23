require 'test_helper'

module Pelusa
  describe Parser do
    describe 'init!' do
      describe 'when including Melbourne parser' do
        it 'shims the Rubinius module' do
          Parser.stubs(:rubinius?).returns false
          Rubinius.methods.must_include :ruby19?
          Rubinius.methods.must_include :ruby18?
        end
      end
      describe 'when no parser is available' do
        it 'raises an exception' do
          Parser.stubs(:rubinius?).returns false
          Parser.stubs(:melbourne?).returns false
          assert_raises(Parser::NoParserError) do
            Parser.init!
          end
        end
      end
    end
  end
end