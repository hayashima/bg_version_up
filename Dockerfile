# コードを実行するコンテナイメージ
FROM ruby:3.0.1

# アクションのリポジトリからコードファイルをコピー
COPY Gemfile /bg_version_up/Gemfile
COPY Gemfile.lock /bg_version_up/Gemfile.lock
COPY main.rb /bg_version_up/main.rb
COPY entrypoint.sh /entrypoint.sh

# dockerコンテナが起動する際に実行されるコードファイル (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
