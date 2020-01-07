@echo off
set FILE=%1
echo @echo off
for /l %%l in (1,1,3) do @for /f "tokens=1,2* delims=:" %%a in ('findstr /n /r "^" %FILE% ^| findstr /r "^%%l:"') do @echo call localvault unseal%%c
