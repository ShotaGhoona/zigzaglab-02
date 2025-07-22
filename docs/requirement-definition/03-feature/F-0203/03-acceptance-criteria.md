# 機能完了基準

## 動作確認項目
- [ ] 7テーブル（admin_users, news, products, inquiries, files, tags, taggables）が正常作成されている
- [ ] 全テーブルでRLS（Row Level Security）が有効化されている
- [ ] **RLSポリシー動作確認**: 匿名で`news`の`published`データが参照可能
- [ ] **管理者権限確認**: Clerk認証ユーザーが全テーブルアクセス可能
- [ ] **匿名投稿確認**: `inquiries`テーブルへの未認証ユーザー投稿が成功する
- [ ] 外部キー制約・UNIQUE制約・CHECK制約が設定通り動作する
- [ ] インデックスが適切に作成され、クエリ実行計画で使用される
- [ ] Supabase Storage の files bucket が作成・アクセス可能
- [ ] Supabase型生成コマンドが正常実行される

## 品質基準
- [ ] 基本的なINSERT・SELECT・UPDATE・DELETE操作が正常実行される
- [ ] 制約違反時に適切なエラーが発生する（重複キー・NULL制約等）
- [ ] **RLSセキュリティテスト**: 匿名で管理データアクセスが403エラーでブロックされる
- [ ] **Clerk認証連携テスト**: JWTトークンで管理者権限が正しく動作する
- [ ] ファイルアップロード・ダウンロードが正常動作する

## ドキュメント・レビュー
- [ ] **マイグレーションファイル**: `supabase/migrations/`にSQL DDLスクリプト配置
- [ ] **環境変数確認**: 既存.envファイルの`hdwdudvsncibvjtuoscr`設定確認
- [ ] **型ファイル生成**: `supabase/types/database.ts`が正しく生成される
- [ ] データベース設計書との整合性確認完了
- [ ] 設計レビュー完了（アーキテクト承認）
- [ ] **RLSポリシーレビュー**: UI権限設計との整合性確認完了