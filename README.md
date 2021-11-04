# バージョンアップ

このアクションは現在の開発ブランチ(hotfix)をバージョンアップして、オープンしているプルリクエストのベースブランチを変更します。
既にバージョンアップ後の開発ブランチをリモートに作成していることが前提です。

## Inputs

## `repo`
**Required** リポジトリ名。  

## `token`
**Required** トークン。  

## `current_version`
**Required** 現在の開発ブランチバージョン

## `after_version`
**Required** バージョンアップ後の開発ブランチバージョン

## 使用例

手動実行を前提としています。

```.github/workflows/main.yml
on:
  workflow_dispatch:
    inputs:
      current_version:
        description: '現在のバージョン'
        required: true
      next_version:
        description: 'バージョンアップ後のバージョン'
        required: true

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Before Branch
        uses: actions/checkout@v2
      - name: Create Release Branch
        env:
          GITHUB_TOKEN: ${{ secrets.TOKEN }}
        run: |
          git checkout -b release-${{ github.event.inputs.current_version }}
          git push origin release-${{ github.event.inputs.current_version }}
      - name: Checkout Before Branch
        uses: actions/checkout@v2
        with:
          ref: hotfix-${{ github.event.inputs.current_version }}
      - name: Create Hotfix Branch
        env:
          GITHUB_TOKEN: ${{ secrets.TOKEN }}
        run: |
          git checkout -b hotfix-${{ github.event.inputs.next_version }}
          git push origin hotfix-${{ github.event.inputs.next_version }}
      - name: version_up
        id: bg_version_up
        uses: hayashima/bg_version_up@v1
        with:
          repo: ${{ github.repository }}
          token: ${{ secrets.GITHUB_TOKEN }}
          current_version: ${{ github.event.inputs.current_version }}
          next_version: ${{ github.event.inputs.next_version }}
```
