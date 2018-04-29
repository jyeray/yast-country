require "yast"
require "ui/dialog"
require_relative "../keyboard_layout"
require_relative 'expert_settings'

Yast.import "UI"
Yast.import "Popup"

module Y2Keyboard
  module Dialogs
    class LayoutSelector < UI::Dialog

      def initialize(keyboard_layouts)
        textdomain "country"
        @keyboard_layouts = keyboard_layouts
      end

      def dialog_options
        Opt(:decorated, :defaultsize)
      end

      def dialog_content
        VBox(
          SelectionBox(
            Id(:layout_lists),
            _("&Keyboard Layout"),
            @keyboard_layouts.map(&:description)
          ),
          HBox(
            HSpacing(),
            PushButton(Id(:expert_settings), _("expert settings")),
            HSpacing()
          ),
          footer
        )
      end

      def accept_handler
        selected_layout = Yast::UI.QueryWidget(:layout_lists, :CurrentItem)
        layout = @keyboard_layouts.find { |x| x.description == selected_layout }
        Y2Keyboard::KeyboardLayout.set_layout(layout)
        finish_dialog
      end

      def expert_settings_handler
        ExpertSettings.run
      end

      def footer
        HBox(
          HSpacing(),
          PushButton(Id(:cancel), Yast::Label.CancelButton),
          PushButton(Id(:accept), Yast::Label.AcceptButton),
          HSpacing()
        )
      end
    end
  end
end
