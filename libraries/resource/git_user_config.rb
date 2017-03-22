class ChefSshd
  class Resource
    class GitUserConfig < Chef::Resource
      resource_name :sshd_git_user_config

      default_action :deploy
      allowed_actions :deploy

      property :exists, [TrueClass, FalseClass]
      property :revision, String

      property :release_path, String, default: lazy { ::File.join(home_path, '.ssh') }
      property :git_repo, String
      property :git_branch, String
      property :home_path, String
    end
  end
end
