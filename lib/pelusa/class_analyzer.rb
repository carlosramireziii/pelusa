class Pelusa::ClassAnalyzer
  # Public: Initializes a ClassAnalyzer.
  #
  # klass - The class AST node.
  def initialize(klass)
    @klass = klass
  end

  # Public: Returns the name of the Class being analyzed.
  #
  # Returns the String name.
  def class_name
    name = @klass.name
    name.name
  end

  # Public: Analyzes a class with a series of lints.
  #
  # lints - The lints to check for.
  #
  # Returns a collection of Analysis, one for each lint.
  def analyze(lints)
    lints.map do |lint_class|
      lint = lint_class.new
      lint.check(@klass)
    end
  end
end
