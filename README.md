# memo-share

デスクトップの `web-memo.txt` に書いて保存すると、GitHub Pages で見えるメモページ。

- ページ: https://mnk2002.github.io/memo-share/ （30秒ごとに自動で読み直す）
- 同期: `start-sync.bat` で `sync-memo.ps1` を裏で起動（3秒ごとに更新を見て push。ログは `sync.log`）
- **公開ページ**。URLを知っていれば誰でも読める。パスワードやAPIキーは書かない
- 履歴は1コミットに保つ（amend + force push）。古いメモは残さない
- 止めるとき: タスクマネージャーで `sync-memo.ps1` を動かしている powershell を終了
