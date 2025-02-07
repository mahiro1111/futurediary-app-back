# futurediary-app-back

## 初期設定
①dockerを立ち上げる

②下記コマンドで実行環境を立ち上げます。

```
docker compose build
docker compose up -d
```

③dbを作成します
```
docker compose exec web rake db:create
```

④URLにアクセスし、立ち上がったことを確認する
http://localhost:3000/