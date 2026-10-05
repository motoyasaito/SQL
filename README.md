研修用の資料です。

## MySQLサーバーの立ち上げ方

### 前提条件
- Docker Desktopがインストールされていること
- Docker Composeが利用可能であること

### 起動手順

1. **コンテナの起動**
   ```bash
   docker-compose up -d
   ```

2. **起動確認**
   ```bash
   docker-compose ps
   ```
   `mysql-container`が`Up`状態になっていることを確認してください。

3. **ログの確認（必要に応じて）**
   ```bash
   docker-compose logs mysql
   ```

### MySQLへの接続

#### Docker環境内のbashシェルに入る

```bash
docker exec -it mysql-container bash
```

bashシェル内では、以下のコマンドでMySQLに接続できます：
```bash
mysql -uroot -proot --default-character-set=utf8
```

#### コマンドラインから直接接続（日本語入力対応）

```bash
docker exec -it mysql-container mysql -uroot -proot --default-character-set=utf8
```

> **重要**: 
> - 接続後、`SET NAMES utf8;`を実行することで、文字コードを確実に設定できます。
> - 文字コードが正しく設定されているか確認するには：
>   ```sql
>   SHOW VARIABLES LIKE 'character%';
>   ```
>   `character_set_client`、`character_set_connection`、`character_set_results`が`utf8`になっていることを確認してください。

MySQLから抜ける場合は、以下のコマンドを実行してください。
```sql
exit
```
または
```sql
quit
```

#### 接続情報
- **ホスト**: `localhost`
- **ポート**: `3306`
- **ユーザー名**: `root`
- **パスワード**: `root`
- **データベース名**: `demo`

#### 外部ツールから接続する場合
以下の情報を使用してMySQLクライアント（例：MySQL Workbench、DBeaver、TablePlusなど）から接続できます。

```
ホスト: localhost
ポート: 3306
ユーザー名: root
パスワード: root
データベース: demo
```

### 停止・削除

> **自動バックアップ機能**: 
> - コンテナ起動時: ホスト側の`Buckup`ディレクトリ配下のファイルが自動的にDocker環境内の`/tmp`にコピーされます。
> - コンテナ停止時: Docker環境内の`/tmp`配下の`.sql`ファイルが自動的にホスト側の`Buckup`ディレクトリにバックアップされます。
> - **推奨**: 通常は`/mnt/buckup`（ホスト側の`Buckup`ディレクトリにマウント）に直接保存することで、即座にホスト側に反映されます。

#### コンテナの停止
```bash
docker-compose stop
```
停止時に、`/tmp`配下の`.sql`ファイルが自動的に`Buckup`ディレクトリにバックアップされます。

#### コンテナの停止と削除（データは保持）
```bash
docker-compose down
```
停止時に、`/tmp`配下の`.sql`ファイルが自動的に`Buckup`ディレクトリにバックアップされます。

#### コンテナの停止と削除（データも削除）
```bash
docker-compose down -v
```
> **注意**: `-v`オプションを使用すると、ボリュームも削除されますが、`Buckup`ディレクトリはホスト側のディレクトリなので削除されません。停止時にバックアップは実行されます。

### データベースのバックアップ（ダンプ）

> **注意**: 
> - ダンプを取得する前に、MySQLコンテナが起動していることを確認してください。`docker-compose ps`でコンテナの状態を確認できます。
> - 以下の操作は、Docker環境内のbashシェルに入ってから実行してください。
> - バックアップ先フォルダ:
>   - **ローカル（ホスト側）**: `Buckup/XXX.sql`
>   - **Linux（Docker環境内）**: `/mnt/buckup/XXX.sql`
>   - `/mnt/buckup`はホスト側の`Buckup`ディレクトリにマウントされているため、`/mnt/buckup`に保存するとホスト側の`Buckup`ディレクトリに即座に反映されます。

#### 特定のデータベースをダンプする

```bash
# 1. Docker環境内のbashシェルに入る
docker exec -it mysql-container bash

# 2. bashシェル内でダンプを実行
# 保存先: /mnt/buckup/backup_demo.sql（ホスト側のBuckup/backup_demo.sqlに対応）
mysqldump -uroot -proot --default-character-set=utf8 demo > /mnt/buckup/backup_demo.sql
```

#### すべてのデータベースをダンプする

```bash
# 1. Docker環境内のbashシェルに入る
docker exec -it mysql-container bash

# 2. bashシェル内でダンプを実行
# 保存先: /mnt/buckup/backup_all.sql（ホスト側のBuckup/backup_all.sqlに対応）
mysqldump -uroot -proot --default-character-set=utf8 --all-databases > /mnt/buckup/backup_all.sql
```

### データベースの復元

> **注意**: 
> - 以下の操作は、Docker環境内のbashシェルに入ってから実行してください。
> - バックアップファイルのパス:
>   - **ローカル（ホスト側）**: `Buckup/XXX.sql`
>   - **Linux（Docker環境内）**: `/mnt/buckup/XXX.sql`
>   - `/mnt/buckup`はホスト側の`Buckup`ディレクトリにマウントされているため、ホスト側の`Buckup`ディレクトリにあるファイルは`/mnt/buckup`から直接アクセスできます。

#### SQLファイルから復元する

```bash
# 1. Docker環境内のbashシェルに入る
docker exec -it mysql-container bash

# 2. bashシェル内で復元を実行
# 復元元: /mnt/buckup/backup_demo.sql（ホスト側のBuckup/backup_demo.sqlに対応）
mysql -uroot -proot --default-character-set=utf8 demo < /mnt/buckup/backup_demo.sql
```

#### すべてのデータベースを復元する

```bash
# 1. Docker環境内のbashシェルに入る
docker exec -it mysql-container bash

# 2. bashシェル内で復元を実行
# 復元元: /mnt/buckup/backup_all.sql（ホスト側のBuckup/backup_all.sqlに対応）
mysql -uroot -proot --default-character-set=utf8 < /mnt/buckup/backup_all.sql
```

#### 復元前にデータベースを再作成する場合

```bash
# 1. Docker環境内のbashシェルに入る
docker exec -it mysql-container bash

# 2. bashシェル内でデータベースを削除して再作成
mysql -uroot -proot -e "DROP DATABASE IF EXISTS demo; CREATE DATABASE demo;"

# 3. bashシェル内でダンプファイルから復元
# 復元元: /mnt/buckup/backup_demo.sql（ホスト側のBuckup/backup_demo.sqlに対応）
mysql -uroot -proot --default-character-set=utf8 demo < /mnt/buckup/backup_demo.sql
```

### Docker環境とホスト間のファイルコピー

> **注意**: 
> - `/mnt/buckup`はホスト側の`Buckup`ディレクトリにマウントされているため、通常は`docker cp`コマンドは不要です。
> - ホスト側の`Buckup`ディレクトリのファイルは`/mnt/buckup`から直接アクセスでき、`/mnt/buckup`に保存したファイルはホスト側の`Buckup`ディレクトリに即座に反映されます。

#### ホスト側からDocker環境内にファイルをコピーする（通常は不要）

`/mnt/buckup`以外の場所にコピーする場合のみ使用：
```bash
# ホスト側: Buckup/backup_demo.sql → Docker環境内: /tmp/backup_demo.sql
docker cp Buckup/backup_demo.sql mysql-container:/tmp/backup_demo.sql
```

#### Docker環境内からホスト側にファイルをコピーする（通常は不要）

`/mnt/buckup`以外の場所からコピーする場合のみ使用：
```bash
# Docker環境内: /tmp/backup_demo.sql → ホスト側: Buckup/backup_demo.sql
docker cp mysql-container:/tmp/backup_demo.sql Buckup/backup_demo.sql
```

### トラブルシューティング

#### ポート3306が既に使用されている場合
`docker-compose.yml`の`ports`セクションを変更してください。
```yaml
ports:
  - "3307:3306"  # ホスト側のポートを3307に変更
```

#### コンテナが起動しない場合
ログを確認してください。
```bash
docker-compose logs mysql
```