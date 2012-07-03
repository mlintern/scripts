#!/bin/sh

# This script will pull the production server list and create a csv in the Documents folder

./collectamazonserverinfo.sh

# This script will create the all other servers list for TMUX
./listallotherproductionservers.sh > ~/.tmux.prod-other.sh && sudo chmod +x ~/.tmux.prod-other.sh

# This script will create the all  servers list for TMUX
./listallproductionservers.sh > ~/.tmux.prod-all.sh && sudo chmod +x ~/.tmux.prod-all.sh

# This script will create the all  servers list for TMUX
./listallproductionappservers.sh > ~/.tmux.prod-app.sh && sudo chmod +x ~/.tmux.prod-app.sh

# This script will create the release servers list for TMUX
./listallproductionreleaseservers.sh > ~/.tmux.prod-release.sh && sudo chmod +x ~/.tmux.prod-release.sh

# This script will create the test environment servers list for TMUX
./listalltestservers.sh > ~/.tmux.test-all.sh && sudo hmod +x ~/.tmux.test-all.sh
