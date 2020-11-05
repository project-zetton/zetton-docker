export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="ys"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
)

[ -f $ZSH/oh-my-zsh.sh ] && source $ZSH/oh-my-zsh.sh

# path
export PATH="${HOME/.local/bin}:${PATH}"
export LD_LIBRARY_PATH="/usr/local/lib:/usr/lib:${LD_LIBRARY_PATH}"

# ros
export ROSCONSOLE_FORMAT='[${severity}][${time}][${node}:${logger}]: ${message}'
alias rcd='roscd'
alias e='rosed'
alias rmk='catkin_make -j8'
alias rt="catkin_make run_tests"
alias rcl='catkin_make clean'
alias rpkg='catkin_create_pkg'
alias rcore='roscore &'
alias rl='roslaunch'
alias rr='rosrun'
alias rlog="sudo vim ${ROS_ROOT}/config/rosconsole.config"
source /opt/ros/melodic/setup.zsh

if [ -f /workspace/install/setup.zsh ]; then
   source /workspace/install/setup.zsh
elif [ -f /workspace/devel/setup.zsh ]; then
   source /workspace/devel/setup.zsh
fi
