# windows/db/

Put the Windows database here as `mydb.db`.

This is the file produced by `tool/export_windows_db.dart` (see that file's
header comment for how to run it) — a copy of `assets/db/mydb.db` with the
SQLCipher container encryption removed. The per-field AES encryption
(`encryptAES`/`aesDecrypt` in `lib/util/util.dart`) is untouched, so the row
data here is exactly as protected as it was before, minus that one outer
layer sqflite_sqlcipher can't provide on Windows.

`windows/CMakeLists.txt` bundles this file into the Windows build's
`data/windows_db/mydb.db`. `UpadanSonghro._openWindowsDatabase()` in
`lib/ui/pages/data/upadansonghro.dart` copies it into a writable per-user
location on first run and opens it with `sqflite_common_ffi`.

Delete `tool/export_windows_db.dart` once this file is in place — it isn't
referenced by the app and only exists to produce this file.
