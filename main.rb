require 'octokit'

PROTECT_BRANCH_HEADER = { accept: 'application/vnd.github.v3+json' }
PROTECTION_OPTION = {
  required_pull_request_reviews: {
    required_approving_review_count: 1
  },
  required_status_checks: {
    strict: true,
    contexts: []
  },
  enforce_admins: nil,
  restrictions: nil
}

# コマンドライン引数から取得
github_token, repo, current_version, next_version = ARGV

current_hotfix_branch = "hotfix-#{current_version}"
next_hotfix_branch = "hotfix-#{next_version}"

client = Octokit::Client.new(access_token: github_token)

# デフォルトブランチをバージョンアップした開発ブランチに変更
client.edit_repository(repo, { default_branch: next_hotfix_branch })

# バージョンアップした開発ブランチの設定
client.protect_branch(repo, next_hotfix_branch, PROTECTION_OPTION.merge(PROTECT_BRANCH_HEADER))

# 1つ前の開発ブランチのプロテクト設定解除
client.unprotect_branch(repo, current_hotfix_branch)

# プルリクエストのベースブランチをバージョンアップした開発ブランチに変更
pull_requests = client.pull_requests(repo, state: 'open', base: current_hotfix_branch)

pull_requests.each do |pull_req|
  begin
    client.update_pull_request(repo, pull_req.number, base: next_hotfix_branch)
    puts "No:#{pull_req.number} base_branch:#{current_hotfix_branch}=>#{next_hotfix_branch}"
  rescue Octokit::UnprocessableEntity
    # dependabotが自動でベースブランチを変えた後に更新しようとするとエラーになるので、その場合はスキップする
    puts "プルリクNo:#{pull_req.number}は、既に更新された可能性があります。"
  end
end

# 1つ前の開発ブランチを削除
client.delete_branch(repo, current_hotfix_branch)
