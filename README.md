# wordle_clone

Flutterで制作したWordleのクローンです。

## ビルド

Webサイトとして公開するためのファイル(`.html`, `.js`など)を生成するには、以下のコマンドを実行します。

```shell
flutter build web
```

### 相対パスについて

このアプリを例えば `https://example.com/` のようなURLで公開する場合、上のコマンドで問題ありません。

一方で、 `https://example.com/wordle-clone/` のようなURLで公開する場合には、代わりに次のコマンドを実行してください。

```shell
flutter build web --base-href /wordle-clone/
```