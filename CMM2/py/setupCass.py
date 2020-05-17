import subprocess
import shlex
import os, sys
import conf

branch_dict = {
    'ZezhiWang': ['abd', 'abdOpt', 'sbq'],
    'yingjianwu199868': ['treasNoLog', 'OreasNoLog', 'newCausal'],
    'Dariusrussellkish': ['bsr', 'abd-machine-time']
}

usage = """
usage: 
    to checkout the baseline branch:
        python3 setupCass.py base 
    to checkout other branches recorded in branch_dict in setupCass.py
        python3 setupCass.py <branch-name>
        e.g. python3 setupCass.py abd
"""
if len(sys.argv) == 1 or len(sys.argv) > 2:
    print(usage)
    exit(0)

branch = sys.argv[1]
for k, v in branch_dict.items():
    if branch in v:
        endpoint = f'https://github.com/{k}/cassandra.git'
        break
else:
    # checkout the baseline branch & a recent active endpoint
    print("branch_dict no match")
    branch = '0d464cd25ffbb5734f96c3082f9cc35011de3667'
    endpoint = f'https://github.com/Dariusrussellkish/cassandra.git'

print("endpoint:", endpoint)
print("branch:", branch)

cmds = f"""
echo **********start**********
# rm -rf ~/cassandra
# cd && git clone {endpoint}
cd ~/cassandra && git reset --hard && git checkout {branch}
cp {"~/CCM2/res/build.xml"} .
cp {"~/CCM2/res/build.properties.default"} .
ant build
git status
cd
echo ***********done**********
\n
\n
"""

process = subprocess.Popen(cmds, shell=True)
process.communicate(input=b'\n')
