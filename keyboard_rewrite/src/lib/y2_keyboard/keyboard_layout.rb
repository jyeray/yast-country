require "cheetah"

module Y2Keyboard
  class KeyboardLayout
    attr_reader :code
    attr_reader :description

    LAYOUT_CODE_DESCRIPTIONS = {
      "es" => "Spanish",
      "fr" => "French",
      "us" => "English (US)"
    }

    def initialize(code, description)
      @code = code
      @description = description
    end

    def self.all
      raw_layouts = Cheetah.run("localectl", "list-keymaps", stdout: :capture)
      codes = raw_layouts.lines.map(&:strip)
      codes_with_description = codes.select { |code| LAYOUT_CODE_DESCRIPTIONS.key?(code) }
      codes_with_description.map { |code| KeyboardLayout.new(code, LAYOUT_CODE_DESCRIPTIONS[code]) }
    end

    def self.set_layout(keyboard_layout)
      Cheetah.run("localectl", "set-keymap", keyboard_layout.code)
    end

    def self.set_delay_and_rate(delay, rate)
      Cheetah.run("kbdrate", "-d", delay, "-r", rate)
      Cheetah.run("xset", "r", "rate", delay, rate)
    end
  end
end
