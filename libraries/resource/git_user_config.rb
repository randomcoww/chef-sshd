class ChefSshd
  class Resource
    class GitUserConfig < Chef::Resource
      resource_name :sshd_git_user_config

      default_action :deploy
      allowed_actions :deploy

      property :exists, [TrueClass, FalseClass]
      property :revision, String

      property :release_path, String, default: lazy { ::File.join(home, '.ssh') }
      property :git_repo, String
      property :git_branch, String

      property :user, String
      property :group, String
      property :home, String
    end
  end
end
