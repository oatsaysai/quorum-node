import sys
import os

if (sys.argv[1] == ''):
    print 'false'
    sys.exit(0)

peer_count = int(sys.argv[1], 0)
node = int(os.environ['NODE'])
if (peer_count == node-2):
    print 'true'
else:
    print 'false'
