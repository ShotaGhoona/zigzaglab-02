# Notion API テーブル作成 詳細ガイド

## 公式ドキュメント調査結果

### 重要な制約・要件

1. **テーブル作成時の必須要件**
   - `table_width`を指定する必要がある
   - **最低1つの`table_row`が必要**
   - 各`table_row`の`cells`配列の長さは`table_width`と一致する必要がある

2. **作成方法の制約**
   - テーブルブロック単体では作成できない
   - 必ず`table_row`を含めて作成する必要がある
   - `children`プロパティに`table_row`を含める

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

## 正しい実装方法

### 方法1: ページ作成時に含める

```javascript
const pageData = {
  parent: { database_id: databaseId },
  properties: { /* プロパティ */ },
  children: [
    {
      type: 'table',
      table: {
        table_width: 3,
        has_column_header: true,
        has_row_header: false
      }
    },
    {
      type: 'table_row',
      table_row: {
        cells: [
          [{ type: 'text', text: { content: 'ヘッダー1' } }],
          [{ type: 'text', text: { content: 'ヘッダー2' } }],
          [{ type: 'text', text: { content: 'ヘッダー3' } }]
        ]
      }
    },
    {
      type: 'table_row',
      table_row: {
        cells: [
          [{ type: 'text', text: { content: 'データ1' } }],
          [{ type: 'text', text: { content: 'データ2' } }],
          [{ type: 'text', text: { content: 'データ3' } }]
        ]
      }
    }
  ]
};
```

### 方法2: テーブル作成後に行を追加

```javascript
// 1. まずテーブルを作成
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

// 2. テーブル行を追加
await notion.blocks.children.append({
  block_id: tableBlock.results[0].id,
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

## 実装の修正方針

現在のワークフローでエラーが発生している原因は、テーブルブロックとテーブル行を別々に処理しているため。正しくは：

1. マークダウンテーブルを解析
2. テーブルブロック + 全テーブル行をまとめて配列として生成
3. 一度にページに追加

この方法でテーブルの同期が正常に動作するはずです。