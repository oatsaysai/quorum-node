import sys
import os

if (os.environ['PEER_COUNT'] == ''):
    print 'false'
    sys.exit(0)

peer_count = int(os.environ['PEER_COUNT'], 0)
node = int(os.environ['NODE'])
if (peer_count >= node-2):
    print 'true'
else:
    print 'false'
