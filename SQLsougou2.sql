-- employeesテーブル --
CREATE TABLE employees ( 
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50), 
  position VARCHAR(50), 
  salary INT, 
  created_at DATE DEFAULT (CURRENT_DATE),
  -- DATE型だと日付更新ができないため実装されていません --
  updated_at DATE DEFAULT (CURRENT_DATE)
  );
-- projectsテーブル --
CREATE TABLE projects (
  id INT AUTO_INCREMENT PRIMARY KEY, 
  name VARCHAR(100), 
  budget INT, 
  created_at DATE DEFAULT (CURRENT_DATE),
  -- DATE型だと日付更新ができないため実装されていません --
  updated_at DATE DEFAULT (CURRENT_DATE)
);
-- assignmentsテーブル --
CREATE TABLE assignments (
  id INT AUTO_INCREMENT PRIMARY KEY, 
  employee_id INT, 
  project_id INT,  
  hours INT, 
  created_at DATE DEFAULT (CURRENT_DATE),
  -- DATE型だと日付更新ができないため実装されていません --
  updated_at DATE DEFAULT (CURRENT_DATE),
  FOREIGN KEY (employee_id) REFERENCES employees(id),
  FOREIGN KEY (project_id) REFERENCES projects(id)
);
-- employeesテーブルにデータ挿入 --
INSERT INTO employees(name, position, salary) VALUES  ('山田太郎', 'マネージャー', 700000), ('佐藤花子', 'エン
ジニア', '500000'), ('鈴木次郎', 'エンジニア', 500000);
/*
+----+--------------+--------------------+--------+------------+---------------------+
| id | name         | position           | salary | created_at | updated_at          |
+----+--------------+--------------------+--------+------------+---------------------+
|  1 | 山田太郎     | マネージャー       | 700000 | 2026-10-07 | 2026-10-07 06:26:01 |
|  2 | 佐藤花子     | エンジニア         | 500000 | 2026-10-07 | 2026-10-07 06:26:01 |
|  3 | 鈴木次郎     | エンジニア         | 500000 | 2026-10-07 | 2026-10-07 06:26:01 |
+----+--------------+--------------------+--------+------------+---------------------+
*/
-- projectsテーブルにデータ挿入 --
INSERT INTO projects (name, budget) VALUES ('新製品開発', 10000000), ('マーケティング戦略', 5000000);
/*
+----+-----------------------------+----------+------------+---------------------+
| id | name                        | budget   | created_at | updated_at          |
+----+-----------------------------+----------+------------+---------------------+
|  1 | 新製品開発                  | 10000000 | 2026-10-07 | 2026-10-07 06:28:23 |
|  2 | マーケティング戦略          |  5000000 | 2026-10-07 | 2026-10-07 06:28:23 |
+----+-----------------------------+----------+------------+---------------------+
*/
-- assignmentsテーブルにデータ挿入 --
INSERT INTO assignments (employee_id, project_id, hours) VALUES (1, 1, 100), (2, 1, 150), (3, 2, 200);
/*
+----+-------------+------------+-------+------------+---------------------+
| id | employee_id | project_id | hours | created_at | updated_at          |
+----+-------------+------------+-------+------------+---------------------+
|  1 |           1 |          1 |   100 | 2026-10-07 | 2026-10-07 06:31:22 |
|  2 |           2 |          1 |   150 | 2026-10-07 | 2026-10-07 06:31:22 |
|  3 |           3 |          2 |   200 | 2026-10-07 | 2026-10-07 06:31:22 |
+----+-------------+------------+-------+------------+---------------------+
*/
-- employeesテーブルの全データを取得 --
SELECT * FROM employees;
/*
+----+--------------+--------------------+--------+------------+---------------------+
| id | name         | position           | salary | created_at | updated_at          |
+----+--------------+--------------------+--------+------------+---------------------+
|  1 | 山田太郎     | マネージャー       | 700000 | 2026-10-07 | 2026-10-07 06:26:01 |
|  2 | 佐藤花子     | エンジニア         | 500000 | 2026-10-07 | 2026-10-07 06:26:01 |
|  3 | 鈴木次郎     | エンジニア         | 500000 | 2026-10-07 | 2026-10-07 06:26:01 |
+----+--------------+--------------------+--------+------------+---------------------+
*/
--プロジェクトごとの割り当て時間の合計を取得--
SELECT projects.name AS プロジェクト名, SUM(assignments.hours) AS 合計時間 FROM assignments INNER JOIN projects ON assignments.project_id = projects.id  GROUP BY projects.id, projects.name;
/*
+-----------------------------+--------------+
| プロジェクト名              | 合計時間     |
+-----------------------------+--------------+
| 新製品開発                  |          250 |
| マーケティング戦略          |          200 |
+-----------------------------+--------------+
*/
-- 社員ごとの担当プロジェクト名と作業時間を取得 --
SELECT employees.name AS 社員名, projects.name AS プロジェクト名, assignments.hours AS 作業時間 FROM assignments INNER JOIN employees ON assignments.employee_id = employees.id INNER JOIN projects ON assignments.project_id = projects.id;
/*
+--------------+-----------------------------+--------------+
| 社員名       | プロジェクト名              | 作業時間     |
+--------------+-----------------------------+--------------+
| 山田太郎     | 新製品開発                  |          100 |
| 佐藤花子     | 新製品開発                  |          150 |
| 鈴木次郎     | マーケティング戦略          |          200 |
+--------------+-----------------------------+--------------+
*/
--作業時間が100時間以上の割り当てを取得--
 SELECT employees.name AS 社員名, assignments.hours AS 作業時間 FROM assignments INNER JOIN employees ON assignments.employee_id = employees.id WHERE assignments.hours > 100;
/*
+--------------+--------------+
| 社員名       | 作業時間     |
+--------------+--------------+
| 佐藤花子     |          150 |
| 鈴木次郎     |          200 |
+--------------+--------------+
*/
-- 各プロジェクトの予算に対する作業時間あたりのコストを計算して取得 --
SELECT projects.name AS プロジェクト名, ROUND (projects.budget / SUM(assignments.hours)) AS 作業時間あたりのコスト FROM assignments INNER JOIN projects ON assignments.project_id = projects.id GROUP BY projects.id, projects.name;
/*
+-----------------------------+-----------------------------------+
| 新製品開発                  |                             40000 |
| マーケティング戦略          |                             25000 |
+-----------------------------+-----------------------------------+
*/



