#!/usr/bin/env python
import pytest
import subprocess
import re
import time

def cmd(command_line):
    print('\nTesting: %s' % repr(command_line))
    ret = subprocess.check_output(['cmd', '/c', command_line], stderr=subprocess.STDOUT).decode()
    ret = re.compile(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])').sub('', ret)
    ret = ''.join('\n' if c=='\r' else c for c in ret)
    print(ret)
    return ret

def read_result(filename):
    with open(filename) as f:
        ret = f.read().strip()
    print('%s' % ret)
    return ret

def test_create():
    ret = cmd('localvault create')
    assert ret.startswith('vault-file\nvault-logs\n')
    assert not 'failed' in ret

def test_start():
    ret = cmd('localvault start')
    assert ret.endswith('Creating localvault ... done\n')
    time.sleep(2)

def test_init():
    ret = cmd('localvault init > test.txt')
    ret = read_result('test.txt')
    assert len(ret.split('\n')) == 18
    assert ret.startswith('Unseal Key 1:')
    assert '\nInitial Root Token:' in ret

def test_write_login_script():
    ret = cmd('write-login-script test.txt >login.cmd')
    ret = read_result('login.cmd')
    assert ret.startswith('@echo off\ncall localvault vault login ')
    assert len(ret.split('\n')) == 2

def test_write_unseal_script():
    ret = cmd('write-unseal-script test.txt >unseal.cmd')
    ret = read_result('unseal.cmd')
    assert len(ret.split('\n')) == 4
    assert ret.startswith('@echo off\ncall localvault unseal')

def test_unlock():
    ret = cmd('unseal.cmd')
    assert re.search(r'^Sealed\s+false$', ret, re.MULTILINE)

def test_login():
    ret = cmd('login.cmd')
    assert ret.startswith('Success! You are now authenticated.')
