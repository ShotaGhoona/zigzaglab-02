# Notion API テーブル作成 詳細ガイド（改良版）

## 公式ドキュメント要約

### テーブルブロックの基本構造

Notion のテーブルは **親子関係** で構成される：
- **親**: `table` ブロック（テーブル定義）
- **子**: `table_row` ブロック（行データ）

### テーブルブロック（親）

| プロパティ | 型 | 説明 | 制約 |
|------------|----|----- |------|
| `table_width` | integer | 列数 | **作成後変更不可** |
| `has_column_header` | boolean | 列ヘッダーの有無 | 変更可能 |
| `has_row_header` | boolean | 行ヘッダーの有無 | 変更可能 |

### 🚨 重要な制約・要件

1. **テーブル作成時の必須要件**
   - `table_width`を指定する必要がある
   - **テーブル作成と同時に最低1つの`table_row`が必要**
   - 各`table_row`の`cells`配列の長さは`table_width`と一致する必要がある

2. **作成方法の制約**
   - ❌ テーブルブロック単体では作成できない
   - ✅ 2段階作成: テーブル→行を順次追加
   - ❌ ページレベルでテーブルと行を同時追加は不可

### テーブルブロックの構造

```json
{
  "type": "table",
  "table": {
    "table_width": 3,
    "has_column_header": true,
    "has_row_header": false
  }
}
```

### テーブル行の構造

```json
{
  "type": "table_row",
  "table_row": {
    "cells": [
      [
        {
          "type": "text",
          "text": {
            "content": "セル1の内容"
          },
          "annotations": {
            "bold": false,
            "italic": false,
            "strikethrough": false,
            "underline": false,
            "code": false,
            "color": "default"
          }
        }
      ],
      [
        {
          "type": "text",
          "text": {
            "content": "セル2の内容"
          }
        }
      ],
      [
        {
          "type": "text",
          "text": {
            "content": "セル3の内容"
          }
        }
      ]
    ]
  }
}
```

## 現在のエラーの原因

**エラーメッセージ**: `body.children[2].table.children should be defined, instead was undefined`

**原因**: テーブルブロックを作成する際に、`children`プロパティが定義されていない

## 過去の失敗パターン分析

### ❌ 失敗例1: 空テーブル作成
```javascript
// これは失敗する
{
  type: 'table',
  table: { table_width: 3 },
  children: [] // 空の子配列
}
```
**エラー**: `body.children[0].table.children should be defined`

### ❌ 失敗例2: ページに直接テーブル行追加
```javascript
// これは失敗する（我々の過去の実装）
await notion.blocks.children.append({
  block_id: pageId, // ページIDに直接追加
  children: [tableBlock, tableRowBlock] // 同時追加
});
```

### ✅ 正解パターン: 2段階作成

```javascript
// 1. テーブルブロック作成（空で作成）
const tableBlock = await notion.blocks.children.append({
  block_id: pageId,
  children: [{
    type: 'table',
    table: {
      table_width: 3,
      has_column_header: true,
      has_row_header: false
    }
  }]
});

const tableId = tableBlock.results[0].id;

// 2. テーブル行追加（テーブルIDに追加）
await notion.blocks.children.append({
  block_id: tableId,  // ⚠️ ページIDではなくテーブルID
  children: [{
    type: 'table_row',
    table_row: {
      cells: [
        [{ type: 'text', text: { content: 'セル1' } }],
        [{ type: 'text', text: { content: 'セル2' } }],
        [{ type: 'text', text: { content: 'セル3' } }]
      ]
    }
  }]
});
```

## マークダウンテーブルの変換ロジック

```javascript
function parseMarkdownTable(lines, startIndex) {
  const tableData = [];
  let i = startIndex;
  
  while (i < lines.length && lines[i].includes('|')) {
    const line = lines[i].trim();
    
    // セパレータ行をスキップ
    if (line.match(/^\|[-\s|]+\|$/)) {
      i++;
      continue;
    }
    
    if (line.startsWith('|') && line.endsWith('|')) {
      const cells = line.split('|').slice(1, -1).map(cell => cell.trim());
      tableData.push(cells);
    }
    i++;
  }
  
  return { tableData, endIndex: i - 1 };
}

function createNotionTable(tableData) {
  if (tableData.length === 0) return [];
  
  const tableWidth = tableData[0].length;
  const blocks = [];
  
  // テーブルブロック
  blocks.push({
    type: 'table',
    table: {
      table_width: tableWidth,
      has_column_header: true,
      has_row_header: false
    }
  });
  
  // テーブル行
  tableData.forEach(row => {
    blocks.push({
      type: 'table_row',
      table_row: {
        cells: row.map(cell => [
          {
            type: 'text',
            text: { content: cell },
            annotations: {
              bold: false,
              italic: false,
              strikethrough: false,
              underline: false,
              code: false,
              color: 'default'
            }
          }
        ])
      }
    });
  });
  
  return blocks;
}
```

## 注意点

1. **チャンク処理**: テーブルブロックとテーブル行は連続して送信する必要がある
2. **セル数の一致**: 全ての行のセル数は`table_width`と一致する必要がある
3. **最低要件**: 最低1行のテーブル行が必要
4. **リッチテキスト**: 各セルは配列のリッチテキストオブジェクト形式

## 最適化されたバッチ実装

```javascript
async function createNotionTableOptimized(pageId, tableData) {
  if (tableData.length === 0) return;
  
  const tableWidth = tableData[0].length;
  
  // 1. テーブル作成
  const tableBlock = await notion.blocks.children.append({
    block_id: pageId,
    children: [{
      type: 'table',
      table: {
        table_width: tableWidth,
        has_column_header: true,
        has_row_header: false
      }
    }]
  });
  
  const tableId = tableBlock.results[0].id;
  
  // 2. 全行をバッチ追加（最大100行ずつ）
  const batchSize = 90; // 安全マージン
  for (let i = 0; i < tableData.length; i += batchSize) {
    const batch = tableData.slice(i, i + batchSize);
    
    const rows = batch.map(row => ({
      type: 'table_row',
      table_row: {
        cells: row.map(cellContent => [{
          type: 'text',
          text: { content: cellContent },
          annotations: {
            bold: false,
            italic: false,
            code: false,
            color: 'default'
          }
        }])
      }
    }));
    
    await notion.blocks.children.append({
      block_id: tableId,
      children: rows
    });
    
    // バッチ間の待機
    if (i + batchSize < tableData.length) {
      await new Promise(resolve => setTimeout(resolve, 200));
    }
  }
}
```

## 実装の修正方針

**過去のエラー原因**:
- テーブルブロックとテーブル行をページレベルで同時追加しようとした
- 空のテーブルブロックを作成しようとした

**正しいアプローチ**:
1. マークダウンテーブルを解析
2. **2段階作成**: テーブルブロック → テーブル行
3. テーブル行はテーブルIDに追加（ページIDではない）
4. エラー時のフォールバック処理

この方法でテーブルの同期が正常に動作するはずです。