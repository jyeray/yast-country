require "yast"
require "ui/dialog"
require_relative "../keyboard_layout"

Yast.import "UI"
Yast.import "Popup"

module Y2Keyboard
  module Dialog
    class LayoutSelector < UI::Dialog
      def dialog_options
        Opt(:decorated, :defaultsize)
      end

      def dialog_content
        VBox(
          SelectionBox(
            Id(:layout_lists),
            _("&Keyboard Layout"),
            Y2Keyboard::KeyboardLayout.load.map(&:description)
            ),
          footer
        )
      end

      def accept_handler
        selected_layout = Yast::UI.QueryWidget(:layout_list, :current_item)
        Y2Keyboard::KeyboardLayout.set_layout(selected_layout)
        finish_dialog
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
