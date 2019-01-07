# Copyright (c) [2018] SUSE LLC
#
# All Rights Reserved.
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of version 2 of the GNU General Public License as published
# by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, contact SUSE LLC.
#
# To contact SUSE LLC about this file by physical or electronic mail, you may
# find current contact information at www.suse.com.

require "cheetah"
require_relative "../keyboard_layout"

module Y2Keyboard
  module Strategies
    # Class to deal with file system keyboard configuration management.
    class FileSystemStrategy
      # @return [Array<String>] an array with all available systemd keyboard layouts codes.
      def codes

      end

      # @param keyboard_layout [KeyboardLayout] the keyboard layout to apply in the system.
      def apply_layout(keyboard_layout)

      end

      # @return [KeyboardLayout] the current keyboard layout in the system.
      def current_layout

      end

    end
  end
end
