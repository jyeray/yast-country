require_relative "./test_helper"
require "y2_keyboard/keyboard_layout"

describe Y2Keyboard::KeyboardLayout do
  describe ".all" do
    subject(:load_keyboard_layouts) { Y2Keyboard::KeyboardLayout.all }

    it "returns a lists of keyboard layouts" do
      expected_layouts = ["es", "fr", "us"]
      given_layouts(expected_layouts)

      expect(load_keyboard_layouts).to be_an(Array)
      expect(load_keyboard_layouts).to all(be_an(Y2Keyboard::KeyboardLayout))
      layout_codes_loaded = load_keyboard_layouts.map(&:code)
      expect(layout_codes_loaded).to eq(expected_layouts)
    end

    it "initialize the layout description" do
      layout_list = ["es"]
      given_layouts(layout_list)

      expect(load_keyboard_layouts.first.description).to eq("Spanish")
    end

    it "does not return layouts that does not have description" do
      layout_list = ["zz", "es", "aa"]
      given_layouts(layout_list)

      expect(load_keyboard_layouts.count).to be(1)
      expect(load_keyboard_layouts.first.code).to eq("es")
    end
  end

  describe ".set_layout" do
    subject(:keyboard_layout) { Y2Keyboard::KeyboardLayout }
    
    it "changes the keyboard layout" do
      new_layout = Y2Keyboard::KeyboardLayout.new("es", "Spanish")
      expect(Cheetah).to receive(:run).with(
        "localectl", "set-keymap", new_layout.code
      )

      keyboard_layout.set_layout(new_layout)
    end
  end

  describe ".set_delay_and_rate" do
    subject(:keyboard_layout) { Y2Keyboard::KeyboardLayout }
    rate = 235;
    delay = 10;

    it "sets delay and rate in console" do
      expect(Cheetah).to receive(:run).with(
        "kbdrate", "-d", delay, "-r", rate
      )

      keyboard_layout.set_delay_and_rate(delay, rate)
    end
  end
end
