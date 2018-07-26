module Capistrano
  module Vault
    class SSH < Capistrano::Plugin
      KEY_NAME = "capistrano-vault-signed"

      def set_defaults
        set_if_empty :vault_address, ENV['VAULT_ADDR']
        set_if_empty :vault_ssh_role, 'deploy'
        set_if_empty :vault_ssh_mount_path, 'ssh-client-signer'
      end

      def register_hooks
        stages.each do |stage|
          after stage, 'configure_vault_ssh_options'
          after stage, 'signature_ssh_public_key'
        end
      end

      def define_tasks
        task :configure_vault_ssh_options do
          configure_vault_ssh_options
        end

        task :signature_ssh_public_key do
          signature_ssh_public_key
        end
      end

      private

      def vault_ssh_options
        {
          auth_methods: %w[publickey],
          keys: ["#{Dir.tmpdir}/#{KEY_NAME}"]
        }
      end

      def configure_vault_ssh_options
        env.backend.configure do |sshkit|
          sshkit.backend.configure do |backend|
            backend.ssh_options =
              (backend.ssh_options || {})
              .merge(vault_ssh_options)
          end
        end
      end

      def configure_vault
        ::Vault.address = fetch(:vault_address)
      end

      def generate_rsa_key
        key = OpenSSL::PKey::RSA.new 2048
        File.write("#{Dir.tmpdir}/#{KEY_NAME}", key.to_pem)

        [key, key.public_key]
      end

      def signature_ssh_public_key
        configure_vault
        _, pkey = generate_rsa_key
        payload = { public_key: "ssh-rsa " + [pkey.to_blob].pack('m0') }
        mount_path = fetch(:vault_ssh_mount_path)
        role = fetch(:vault_ssh_role)
        res = ::Vault.post("/v1/#{mount_path}/sign/#{role}", JSON.fast_generate(payload))
        File.write("#{Dir.tmpdir}/#{KEY_NAME}.pub", res.dig(:data, :signed_key).strip)
      end
    end
  end
end
