@echo off

if "%1" == "clean" (
  echo clean
  del test.txt
  del %USERPROFILE%\localvault\localvault-login.cmd
  del %USERPROFILE%\localvault\localvault-unseal.cmd
  goto :eof
)
python -m pytest -v -x %*
