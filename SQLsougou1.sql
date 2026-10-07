--usersテーブル作成--
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE,
  created_at DATE DEFAULT (CURRENT_DATE),
  -- DATE型だと日付更新ができないため実装されていません --
  updated_at DATE DEFAULT (CURRENT_DATE));
  --productsテーブル作成--
CREATE TABLE products (  
  id INT AUTO_INCREMENT PRIMARY KEY, 
  name VARCHAR(100) NOT NULL, 
  price INT, 
  stock INT, 
  created_at DATE DEFAULT (CURRENT_DATE), 
  -- DATE型だと日付更新ができないため実装されていません --
  updated_at DATE DEFAULT (CURRENT_DATE));
  --ordersテーブル作成--
CREATE TABLE orders (
  id INT AUTO_INCREMENT PRIMARY KEY, 
  user_id INT,
  product_id INT,
  products(id), quantity INT, order_date DATE DEFAULT (CURRENT_DATE), 
  created_at DATE DEFAULT (CURRENT_DATE), 
  -- DATE型だと日付更新ができないため実装されていません --
  updated_at DATE DEFAULT (CURRENT_DATE),
  FOREIGN KEY (user_id) REFERENCES users(id), 
  FOREIGN KEY (product_id) REFERENCES products(id),
  --usersテーブルにデータ挿入--
  INSERT INTO users (name, email) VALUES 
  ('田中太郎', 'tanaka@example.com'), 
  ('佐藤花子', 'sato@example.com'), 
  ('山本次郎', 'yamamoto@example.com');
  --productsテーブルにデータ挿入--
  INSERT INTO products (name, price, stock) VALUES 
  ('ノートパソコン', 120000, 20), 
  ('スマートフォン', 80000, 15), 
  ('タブレット', 60000, 30);
  --ordersテーブルにデータ挿入--
  INSERT INTO orders (user_id, product_id, quantity) VALUES 
  (1, 1, 2), 
  (2, 2, 1), 
  (3, 3, 3);
  -- 1. 全ユーザーの情報を取得する。--
  SELECT * FROM users;
  /*
  +----+--------------+----------------------+------------+---------------------+
| id | name         | email                | create_at  | updated_at          |
+----+--------------+----------------------+------------+---------------------+
|  1 | 田中太郎     | tanaka@example.com   | 2026-10-06 | 2026-10-06 17:50:23 |
|  2 | 佐藤花子     | sato@example.com     | 2026-10-06 | 2026-10-06 17:50:23 |
|  3 | 山本次郎     | yamamoto@example.com | 2026-10-06 | 2026-10-06 17:50:23 |
+----+--------------+----------------------+------------+---------------------+
  */
  -- 2. すべての商品とその在庫を取得する。--
  SELECT name, stock FROM products;
  /*
+-----------------------+-------+
| name                  | stock |
+-----------------------+-------+
| ノートパソコン        |    20 |
| スマートフォン        |    15 |
| タブレット            |    30 |
+-----------------------+-------+
*/
--3. 注文履歴を`ユーザー名`, `商品名`, `購入数量`の形式で取得する。--
SELECT users.name AS user_name, products.name AS product_name, orders.quantity FROM orders JOIN users ON orders.user_id = users.id JOIN products ON orders.product_id = products.id;
/*
+--------------+-----------------------+----------+
| user_name    | product_name          | quantity |
+--------------+-----------------------+----------+
| 田中太郎     | ノートパソコン        |        2 |
| 佐藤花子     | スマートフォン        |        1 |
| 山本次郎     | タブレット            |        3 |
+--------------+-----------------------+----------+
*/
--4. 在庫が不足している商品を取得する（在庫が10以下）。--
SELECT * FROM products WHERE stock <= 10;
-- Empty --
-- 5. 各商品の累計売上を計算して取得する。--
SELECT products.name, SUM(orders.quantity * products.price) AS total_sales FROM orders JOIN products ON orders.product_id = products.id GROUP BY products.name;
/*
+-----------------------+-------------+
| name                  | total_sales |
+-----------------------+-------------+
| ノートパソコン        |      240000 |
| スマートフォン        |       80000 |
| タブレット            |      180000 |
+-----------------------+-------------+
*/