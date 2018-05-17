require_relative "test_helper"
require "y2keyboard/keyboard_layout"
require "y2keyboard/strategies/systemd_strategy"

describe Y2Keyboard::Strategies::SystemdStrategy do
  subject(:systemd_strategy) { Y2Keyboard::Strategies::SystemdStrategy.new }

  describe ".all" do
    subject(:load_keyboard_layouts) { Y2Keyboard::Strategies::SystemdStrategy.new.all }

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

  describe ".apply_layout" do
    it "changes the keyboard layout" do
      new_layout = Y2Keyboard::KeyboardLayout.new("es", "Spanish")
      expect(Cheetah).to receive(:run).with(
        "localectl", "set-keymap", new_layout.code
      )

      systemd_strategy.apply_layout(new_layout)
    end
  end

  describe ".load_layout" do
    new_layout = Y2Keyboard::KeyboardLayout.new("es", "Spanish")

    describe "in X server" do
      before do
        allow(Yast::UI).to receive(:TextMode).and_return(false)
      end

      it "changes the current keyboard layout used in xorg" do
        expect(Cheetah).to receive(:run).with("setxkbmap", new_layout.code)

        systemd_strategy.load_layout(new_layout)
      end

      it "do not try to change the current keyboard layout in console" do
        expect(Cheetah).not_to receive(:run).with("loadkeys", new_layout.code)

        systemd_strategy.load_layout(new_layout)
      end
    end

    describe "in text mode" do
      before do
        allow(Yast::UI).to receive(:TextMode).and_return(true)
      end

      it "do not try to change the current keyboard layout in xorg" do
        expect(Cheetah).not_to receive(:run).with("setxkbmap", new_layout.code)

        systemd_strategy.load_layout(new_layout)
      end

      it "changes the current keyboard layout in console" do
        expect(Cheetah).to receive(:run).with("loadkeys", new_layout.code)

        systemd_strategy.load_layout(new_layout)
      end
    end

    describe "using ncurses inside X server" do
      before do
        allow(Yast::UI).to receive(:TextMode).and_return(true)
      end

      describe "when setting current keyboard layout in console" do
        # This tests describes the case when running the module in text mode inside a X server.
        # In that case, when trying to execute 'loadkeys' it will fail due to it should't
        # be execute from X server.
        it "do not raise error" do
          allow(Cheetah).to receive(:run)
            .with("loadkeys", new_layout.code)
            .and_raise(loadkeys_error)

          expect { systemd_strategy.load_layout(new_layout) }.not_to raise_error
        end

        it "log error information" do
          error = loadkeys_error
          allow(Cheetah).to receive(:run)
            .with("loadkeys", new_layout.code)
            .and_raise(error)

          expect(Y2Keyboard::Strategies::SystemdStrategy.log).to receive(:info)
            .with(error.message)
          expect(Y2Keyboard::Strategies::SystemdStrategy.log).to receive(:info)
            .with("Error output:    #{error.stderr}")

          systemd_strategy.load_layout(new_layout)
        end
      end
    end
  end

  describe ".current_layout" do
    it "returns the current used keyboard layout" do
      current_selected_layout_code = "gb"
      given_layouts(["es", current_selected_layout_code, "us"])
      given_a_current_layout(current_selected_layout_code)

      expect(systemd_strategy.current_layout).to be_an(Y2Keyboard::KeyboardLayout)
      expect(systemd_strategy.current_layout.code).to eq(current_selected_layout_code)
    end
  end
end