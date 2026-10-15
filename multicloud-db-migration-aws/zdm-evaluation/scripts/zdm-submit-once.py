#!/usr/bin/env python3
"""Lab-only adapter: one runtime password, five explicitly matched ZDM prompts."""
import errno, getpass, os, pty, re, select, signal, subprocess, sys, termios, time
mode=sys.argv[1:]
if mode not in [['--eval'],['--migrate']]:
    sys.exit('Usage: zdm-submit-once.py --eval|--migrate')
if os.getuid()==0: sys.exit('Run as oracle, not root.')
if sys.stdin.isatty():
    secret=getpass.getpass('Shared ZDM password (input hidden): ')
else:
    secret=sys.stdin.readline().rstrip('\r\n')
if not secret: sys.exit('Password cannot be empty.')
args=[os.environ['ZDM_HOME']+'/bin/zdmcli','migrate','database','-sourcesid',os.environ['ORACLE_SID'],'-sourcenode',subprocess.check_output(['hostname','-f']).decode().strip(),'-srcauth','zdmauth','-srcarg1','user:ec2-user','-srcarg2','identity_file:'+os.path.expanduser('~/.ssh/zdm_source_ed25519'),'-srcarg3','sudo_location:/usr/bin/sudo','-rsp',os.environ['ZDM_RESPONSE_FILE']]
args += ['-eval'] if mode==['--eval'] else ['-pauseafter','ZDM_MONITOR_GG_LAG']
expected=[
 'Enter source database administrative user "SYSTEM" password:',
 'Enter source database administrative user "GGADMIN" password:',
 'Enter target database administrative user "ADMIN" password:',
 'Enter target database administrative user "GGADMIN" password:',
 'Enter Oracle GoldenGate hub administrative user "oggadmin" password:']
pid,fd=pty.fork()
if pid==0:
    attr=termios.tcgetattr(0); attr[3] &= ~termios.ECHO; termios.tcsetattr(0,termios.TCSANOW,attr)
    os.execv(args[0],args)
print('Submitting ZDM evaluation...' if mode==['--eval'] else 'Submitting ZDM migration...',flush=True)
output=b''; seen=0; deadline=time.monotonic()+90; status=None; done=0
try:
    while time.monotonic()<deadline:
        if select.select([fd],[],[],1)[0]:
            try: chunk=os.read(fd,65536)
            except OSError as e:
                if e.errno==errno.EIO: break
                raise
            if not chunk: break
            output+=chunk
            if seen<len(expected) and expected[seen].encode() in output:
                attr=termios.tcgetattr(fd); attr[3] &= ~termios.ECHO; termios.tcsetattr(fd,termios.TCSANOW,attr)
                os.write(fd,(secret+'\n').encode()); seen+=1
        done,status=os.waitpid(pid,os.WNOHANG)
        if done: break
    else:
        os.killpg(pid,signal.SIGTERM)
        print('Submission timed out. Check existing jobs before retrying.',flush=True)
    if status is None or not done:
        _,status=os.waitpid(pid,0)
finally:
    os.close(fd)
print(output.decode(errors='replace').replace(secret,'[REDACTED]'))
secret=None
sys.exit(os.WEXITSTATUS(status) if os.WIFEXITED(status) else 1)
