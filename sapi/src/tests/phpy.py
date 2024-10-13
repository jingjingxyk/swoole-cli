import subprocess
import phpy
try:
    rc = subprocess.run(["launchctl", "managername"],capture_output=True, check=True)
    managername = rc.stdout.decode("utf-8").strip()
    print(managername)
    content = phpy.call('file_get_contents', 'test.txt')

    o = phpy.Object('redis')
    assert o.call('connect', '127.0.0.1', 6379)
    rdata = phpy.call('uniqid')
except subprocess.CalledProcessError:
    reason = "unable to detect macOS launchd job manager"
