require "yast"
require "ui/dialog"

Yast.import "UI"
Yast.import "Popup"

module Y2Keyboard
  module Dialogs
    class ExpertSettings < UI::Dialog

      MIN_WIDTH = 60
      MIN_HEIGHT = 20
      
      def initialize
        textdomain "country"
      end


      def dialog_content
        MinSize(
          MIN_WIDTH,
          MIN_HEIGHT,
          VBox(
            InputField(Id(:rate), Opt(:hstretch), _("Repeat &Rate")),
            InputField(Id(:delay), Opt(:hstretch), _("De&lay before Repetition Starts")),
          )
        )
      end

    end
  end
end