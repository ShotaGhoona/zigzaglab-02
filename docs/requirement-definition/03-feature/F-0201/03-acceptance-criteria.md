# 機能完了基準

## 動作確認項目
- [ ] `npm run dev` で開発サーバーが正常起動（localhost:3000）
- [ ] TypeScript エラー・警告がゼロ
- [ ] ESLint・Prettier が正常動作（`npm run lint`）
- [ ] shadcn/ui Button コンポーネントがページに表示される
- [ ] `npm run build` が正常完了（ビルドエラーなし）
- [ ] ディレクトリ構造が設計通りに作成されている

## 品質基準
- [ ] TypeScript strict mode でコンパイルエラーなし
- [ ] パッケージ脆弱性スキャン（`npm audit`）でクリティカル問題なし
- [ ] ビルド時間が30秒以内
- [ ] 開発サーバー起動時間が5秒以内

## ドキュメント・レビュー
- [ ] README.md に開発環境構築手順記載
- [ ] package.json にスクリプト・依存関係が適切に記載  
- [ ] 主要設定ファイル（tsconfig.json, next.config.js）にコメント追加
- [ ] 設計レビュー完了（アーキテクト承認）
- [ ] コードレビュー完了（シニア開発者承認）