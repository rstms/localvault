# localvault Makefile for use on unix-like
#

VAULT_DIR:= $(HOME)/.localvault

.PHONY: test install clean

test:
	python3 -m pytest -v -x -s

install:
	mkdir -p ${VAULT_DIR} 
	cp localvault ${VAULT_DIR}
	cp docker-compose.yml ${VAULT_DIR}

clean:
	rm -rf .cache
	rm -rf tests/__pycache__
	rm -rf tests/*.pyc
	rm -rf .pytest_cache
	rm -f test.txt
	rm -f localvault-unseal.cmd
	rm -f localvault-login.cmd
	rm -f localvault-unseal
	rm -f localvault-login
