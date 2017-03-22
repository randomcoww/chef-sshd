class ChefSshd
  class Provider
    class GitUserConfig < Chef::Provider
      provides :sshd_git_user_config, os: "linux"

      def load_current_resource
        @current_resource = ChefSshd::Resource::GitUserConfig.new(new_resource.name)

        current_resource.exists(::File.directory?(new_resource.release_path))
        if current_resource.exists
          current_resource.revision(git_provider.find_current_revision)
        else
          current_resource.revision(nil)
        end

        current_resource
      end

      def action_deploy
        create_release_path
        git_repo.run_action(:sync)

        if !current_resource.exists || current_resource.revision != git_provider.find_current_revision
          converge_by("Fetch user config: #{new_resource}") do
          end
        end
      end


      private

      def create_release_path
        Chef::Resource::Directory.new(::File.dirname(new_resource.release_path), run_context).tap do |r|
          r.recursive true
        end.run_action(:create_if_missing)
      end

      def git_provider
        @git_provider ||= git_repo.provider_for_action(:nothing)
      end

      def git_repo
        @git_repo ||= Chef::Resource::Git.new(new_resource.name, run_context).tap do |r|
          r.repository new_resource.git_repo
          r.branch new_resource.git_branch
          r.destination new_resource.release_path
        end
      end
    end
  end
end
