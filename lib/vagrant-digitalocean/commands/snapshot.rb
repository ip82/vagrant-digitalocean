require 'optparse'

module VagrantPlugins
  module DigitalOcean
    module Commands
      class Snapshot < Vagrant.plugin('2', :command)
        def execute
          opts = OptionParser.new do |o|
            o.banner = 'Usage: vagrant snapshot [snapshot-name] (optional)'
          end

          argv = parse_options(opts)

          with_target_vms(argv) do |machine|
            machine.action(:snapshot)
          end

          0
        end
      end
    end
  end
end
