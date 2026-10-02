@echo off
rem Start the memo sync watcher in a hidden window. Log: sync.log
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Start-Process powershell -WindowStyle Hidden -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-File','%~dp0sync-memo.ps1' -RedirectStandardOutput '%~dp0sync.log'"
