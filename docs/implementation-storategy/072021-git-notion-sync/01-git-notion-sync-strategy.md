# Git ↔ Notion 同期システム 初期実装戦略書

## 概要

Git-Notion-Strategy.md で定義されたシステムを実装する。まずは片方向同期（Git→Notion）から開始し、段階的に双方向同期を実現する。

## 実装フェーズ

### フェーズ1: 基盤準備
- [ ] 共有Workflowリポジトリの作成
- [ ] Notion DBの設計・作成
- [ ] Secretsの設定

### フェーズ2: 片方向同期実装
- [ ] GitHub Actions Workflowの作成
- [ ] テストリポジトリでの動作検証
- [ ] 既存プロジェクトへの導入

### フェーズ3: 運用体制構築
- [ ] テンプレートリポジトリの作成
- [ ] 導入ガイドの整備
- [ ] モニタリング体制の構築

### フェーズ4: 双方向同期（将来）
- [ ] Notion→Git同期機能の実装
- [ ] コンフリクト解決機能の追加

## 詳細実装手順

### 1. 共有Workflowリポジトリの作成

#### 1.1 リポジトリ作成
```bash
# 新しいリポジトリを作成（GitHub上で）
# リポジトリ名: your-org/.github
```

#### 1.2 共有Workflowファイル作成
ファイルパス: `.github/workflows/notion-sync.yml`

```yaml
name: Reusable – Docs to Notion

on:
  workflow_call:
    inputs:
      md-root:
        description: 'Root directory for markdown files'
        required: false
        default: '.'
        type: string
      file-patterns:
        description: 'File patterns to include'
        required: false
        default: '**/*.md'
        type: string
    secrets:
      NOTION_TOKEN:
        required: true
      NOTION_DATABASE_ID:
        required: true

jobs:
  notion-sync:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Get changed files
        id: changed-files
        uses: tj-actions/changed-files@v40
        with:
          files: |
            requirement-definition/**/*.md
            docs/**/*.md

      - name: Sync to Notion
        if: steps.changed-files.outputs.any_changed == 'true'
        uses: JoshStern/push-md-to-notion@v0.3.0
        with:
          notion-token: ${{ secrets.NOTION_TOKEN }}
          notion-database-id: ${{ secrets.NOTION_DATABASE_ID }}
          md-root: ${{ inputs.md-root }}
          files: ${{ steps.changed-files.outputs.all_changed_files }}

      - name: Report sync results
        if: steps.changed-files.outputs.any_changed == 'true'
        run: |
          echo "Synced files to Notion:"
          echo "${{ steps.changed-files.outputs.all_changed_files }}"
```

#### 1.3 バージョンタグの作成
```bash
git tag v1.0.0
git push origin v1.0.0
```

### 2. Notion データベースの作成

#### 2.1 データベース構造
以下のプロパティを持つNotionデータベースを作成：

| プロパティ名 | 型 | 説明 |
|-------------|----|----- |
| Title | Title | ファイル名（拡張子なし） |
| Repo | Select | リポジトリ名 |
| Folder | Multi-select | フォルダパス |
| Path | Text | 完全ファイルパス |
| Git SHA | Text | 最新コミットSHA |
| Last Synced | Date | 最終同期日時 |
| Status | Select | Active, Archived |

#### 2.2 権限設定
- 初期段階では「コメント可」に設定
- 編集権限は双方向同期実装まで制限

### 3. 各リポジトリでの設定

#### 3.1 Secretsの設定
各リポジトリの Settings → Secrets and variables → Actions で以下を設定：

```
NOTION_TOKEN: notion_api_key_here
NOTION_DATABASE_ID: database_id_here
```

#### 3.2 Workflowファイル作成
ファイルパス: `.github/workflows/docs-to-notion.yml`

```yaml
name: Docs → Notion Sync

on:
  push:
    branches: [docs, main]
    paths:
      - 'requirement-definition/**/*.md'
      - 'docs/**/*.md'

jobs:
  sync:
    uses: your-org/.github/.github/workflows/notion-sync.yml@v1.0.0
    secrets:
      NOTION_TOKEN: ${{ secrets.NOTION_TOKEN }}
      NOTION_DATABASE_ID: ${{ secrets.NOTION_DATABASE_ID }}
```

### 4. テスト・検証手順

#### 4.1 基本動作テスト
1. テスト用リポジトリでMarkdownファイルを作成
2. docsブランチにpush
3. GitHub Actionが正常に実行されることを確認
4. Notion DBに正しくデータが作成されることを確認

#### 4.2 更新テスト
1. 既存のMarkdownファイルを編集
2. docsブランチにpush
3. Notion DBの該当レコードが更新されることを確認

#### 4.3 複数ファイルテスト
1. 複数のMarkdownファイルを同時に変更
2. 全てのファイルが正しく同期されることを確認

### 5. 運用体制の構築

#### 5.1 テンプレートリポジトリ作成
```
template-repo/
├── .github/
│   └── workflows/
│       └── docs-to-notion.yml
├── docs/
│   └── README.md
├── requirement-definition/
│   └── README.md
└── README.md
```

#### 5.2 導入ガイド作成
新規プロジェクト向けの導入手順書を作成：
- テンプレートからのリポジトリ作成手順
- Secretsの設定手順
- 初回同期の実行・確認手順

#### 5.3 モニタリング設定
- GitHub Action実行結果の監視
- 失敗時のSlack通知設定
- 月次での同期状況レポート

## 前提条件・環境設定

### 必要なアクセス権限
- GitHub Organization admin権限
- Notion workspace admin権限
- 各リポジトリのSettings編集権限

### 必要なツール・サービス
- GitHub Actions
- Notion API
- JoshStern/push-md-to-notion Action

## 完成基準

### フェーズ1完成基準
- [ ] 共有Workflowリポジトリが作成され、v1.0.0タグがリリースされている
- [ ] Notion DBが設計通りに作成されている
- [ ] テスト用リポジトリでSecrets設定が完了している

### フェーズ2完成基準
- [ ] テスト用リポジトリで片方向同期が正常に動作する
- [ ] 複数ファイルの同時更新が正しく処理される
- [ ] エラーハンドリングが適切に動作する

### フェーズ3完成基準
- [ ] テンプレートリポジトリが作成されている
- [ ] 導入ガイドが整備されている
- [ ] 既存プロジェクト1つ以上で実際に運用が開始されている

## トラブルシューティング

### よくある問題と解決策

#### 1. Notion API認証エラー
**症状**: Notion APIへの接続が失敗する
**原因**: NOTION_TOKENの設定ミスまたは権限不足
**解決策**: 
- インテグレーションキーを再確認
- Notion DBへのアクセス権限を確認

#### 2. GitHub Action実行エラー
**症状**: Workflowが正常に実行されない
**原因**: Secretsの設定ミスまたはWorkflowファイルの構文エラー
**解決策**:
- Secrets設定を再確認
- YAML構文をvalidateする

#### 3. ファイルが同期されない
**症状**: Markdownファイルを更新してもNotionに反映されない
**原因**: ファイルパスがトリガー条件に一致していない
**解決策**:
- Workflow内のpathsパターンを確認
- 対象ファイルがトリガー条件に含まれているか確認

## 次のアクション

フェーズ1〜3の完了後：
1. 双方向同期機能の設計・実装（フェーズ4）
2. 大規模運用に向けた最適化
3. APIレート制限対応
4. 詳細なログ・メトリクス収集

## 参考資料

- [GitHub Actions Reusable Workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
- [Notion API Documentation](https://developers.notion.com/)
- [JoshStern/push-md-to-notion Action](https://github.com/JoshStern/push-md-to-notion)