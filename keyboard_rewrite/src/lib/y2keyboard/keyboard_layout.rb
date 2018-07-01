module Y2Keyboard
  # This class represents a keyboard layout. Also have methods to interact with the system.
  class KeyboardLayout
    attr_reader :code
    attr_reader :description
    @@strategy
    @@layout_definitions

    def initialize(code, description)
      @code = code
      @description = description
    end

    def self.all
      @@layout_definitions.map { |x| KeyboardLayout.new(x["code"], x["description"]) }
    end

    def self.use(strategy)
      @@strategy = strategy
    end

    def self.layout_definitions(layout_definitions)
      @@layout_definitions = layout_definitions
    end
  end
end
