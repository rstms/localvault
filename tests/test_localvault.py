#!/usr/bin/env python
import pytest
import subprocess
import re
import time
import platform
import os.path

S = { 
    'Windows': {
        'SYSTEM': 'Windows',
        'SHEBANG': '@echo off',
        'SUFFIX': '.cmd',
        'SHELL': 'cmd',
        'SHARG': '/c'
    },
    'Linux': {
        'SYSTEM': 'Linux',
        'SHEBANG': '#!/bin/sh',
        'SUFFIX': '',
        'SHELL': '/bin/bash',
        'SHARG': '-c'
    }
}[platform.system()]
       
def cmd(command_line):
    print('\nTesting: %s' % repr(command_line))
    try:
        ret = subprocess.check_output([S['SHELL'], S['SHARG'], command_line], stderr=subprocess.STDOUT).decode('UTF-8')
    except subprocess.CalledProcessError as ex:
        ret = ex.output
    r=re.compile(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])')
    ret = r.sub('', str(ret))
    if S['SYSTEM'] == 'Windows':
        ret = ''.join('' if c=='\r' else c for c in ret)
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
    print(repr(ret))
    assert re.match(r'.*Creating localvault ...\s+Creating localvault ... done\s*Starting vault ...\s+Starting vault ... done\s*$', ret)

def test_init():
    time.sleep(2)
    ret = cmd('localvault init > test.txt')
    ret = read_result('test.txt')
    assert len(ret.split('\n')) == 18
    assert ret.startswith('Unseal Key 1:')
    assert '\nInitial Root Token:' in ret

def test_write_unseal_script():
    filename = 'localvault-unseal%s' % S['SUFFIX']
    pathname = os.path.join(os.path.expanduser('~'), '.localvault', filename)
    ret = cmd('localvault write-unseal-script test.txt')
    ret = read_result(pathname)
    assert len(ret.split('\n')) == 4
    pattern = '%s\nvault operator unseal ' % S['SHEBANG']
    assert ret.startswith(pattern)

def test_unseal():
    ret = cmd('localvault-unseal')
    assert re.search(r'^Sealed\s+false$', ret, re.MULTILINE)

def test_write_login_script():
    filename = 'localvault-login%s' % S['SUFFIX']
    pathname = os.path.join(os.path.expanduser('~'), '.localvault', filename)
    ret = cmd('localvault write-login-script test.txt')
    ret = read_result(pathname)
    assert len(ret.split('\n')) == 2
    pattern = '%s\nvault login ' % S['SHEBANG']
    assert ret.startswith(pattern)

def test_login():
    ret = cmd('localvault-login')
    assert ret.startswith('Success! You are now authenticated.')
