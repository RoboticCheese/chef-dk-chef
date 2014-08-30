# Encoding: UTF-8
#
# Cookbook Name:: chef-dk
# Library:: provider/chef_dk_windows
#
# Copyright 2014, Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/provider'
# Core Chef didn't get the windows_package resource until 11.12.0
if Gem::Version.new(Chef::VERSION) >= Gem::Version.new('11.12.0')
  require 'chef/resource/windows_package'
end
require_relative 'provider_chef_dk'
require_relative 'resource_chef_dk'

class Chef
  class Provider
    class ChefDk < Provider
      # A Chef provider for the Chef-DK Windows packages
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class Windows < ChefDk
        private

        #
        # Override the package resource platform-specific tailoring
        # (A `source` for .msi packages)
        #
        def tailor_package_resource_to_platform
          @package.source(download_path)
        end

        #
        # Override the class to be used for the package resource
        # (Chef::Resource::WindowsPackage for .msi packages)
        #
        # @return [Chef::Resource::WindowsPackage]
        #
        def package_resource_class
          Chef::Resource::WindowsPackage
        end

        #
        # Override the platform version to be used in the package URL
        # (The URL has "2008r2" for all versions of Windows)
        #
        # @return [String]
        #
        def platform_version
          '2008r2'
        end

        #
        # Override the package file name's elements array
        # (Add a couple of "windows" for the .msi packages)
        #
        # @return [Array]
        #
        def package_file_elements
          [PACKAGE_NAME, 'windows', "#{version}.windows"]
        end

        #
        # Return the extension of package files used by this system
        #
        # @return [String]
        #
        def package_file_extension
          '.msi'
        end
      end
    end
  end
end
