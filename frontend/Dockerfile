# フロントエンド開発環境用 Dockerfile
FROM node:18-alpine

# 作業ディレクトリ設定
WORKDIR /app

# パッケージファイルコピー（キャッシュ効率化）
COPY package*.json ./

# 依存関係インストール（開発用）
RUN npm ci

# ソースコードコピー
COPY . .

# ポート公開
EXPOSE 3000

# 開発サーバー起動（ホットリロード有効）
CMD ["npm", "run", "dev"]