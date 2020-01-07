@echo off
set FILE=%1
echo @echo off
for /f "tokens=1,2* delims=:" %%a in ('findstr /r "Root" %FILE%') do @echo call localvault vault login%%b
