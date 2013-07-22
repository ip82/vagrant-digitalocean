require 'vagrant-digitalocean/helpers/client'

module VagrantPlugins
  module DigitalOcean
    module Actions
      class Snapshot
        include Helpers::Client

        def initialize(app, env)
          @app = app
          @machine = env[:machine]
          @client = client
          @logger = Log4r::Logger.new('vagrant::digitalocean::snapshot')
        end

        def call(env)
          # submit power off droplet request
          result = @client.request("/droplets/#{@machine.id}/snapshot")

          # wait for request to complete
          env[:ui].info I18n.t('vagrant_digital_ocean.info.taking_snapshot')
          @client.wait_for_event(env, result['event_id'])

          # refresh droplet state with provider
          Provider.droplet(@machine, :refresh => true)

          @app.call(env)
        end
      end
    end
  end
end
