@echo off

if "%1" == "clean" (
  echo clean
  rm test.txt
  rm login.cmd
  rm unseal.cmd
  goto :eof
)
python -m pytest -v -x %*
