#!/bin/bash

vms=($(vboxmanage list vms | awk '{ print $1 }'))
nvm=${#vms[@]}

if [ ${nvm:-0} -le 0 ]; then
  echo 'No VMs; exiting'
  exit
fi

vbox::autostart()
{
  local vm=${1:-}
  local state=${2:-}
  local result

  if [ ! -z "${vm}" ]; then
    if [ ! -z "${state}" ]; then
      vboxmanage modifyvm ${vm} --autostart-enabled ${state}
    fi
    result=$(vboxmanage showvminfo ${vm} --machinereadable | egrep autostart-enabled | awk -F= '{ print $2 }')
  fi
  echo ${result:-null}
}

vbox::autostop()
{
  local vm=${1:-}
  local state=${2:-}
  local result

  if [ ! -z "${vm}" ]; then
    if [ ! -z "${state}" ]; then
      vboxmanage modifyvm ${vm} --autostop-type savestate
    fi
    result=$(vboxmanage showvminfo ${vm} --machinereadable | egrep autostop-type | awk -F= '{ print $2 }')
  fi
  echo ${result:-null}
}

vbox::vms()
{
  echo $(vboxmanage list vms | awk '{ print $1 }')
}

vbox::vms.running()
{
  echo $(vboxmanage list runningvms | awk '{ print $1 }')
}

vbox::start()
{
  local vm=${1:-}
  local type=${2:-headless}
  local result

  if [ ! -z "${vm}" ]; then
    if [ ! -z "${type}" ]; then
      vboxmanage startvm ${vm} --type=${type}
    fi
    result=$(vbox::vms.running | egrep "${vm}")
  fi
  echo ${result:-null}
}

vbox::stop()
{
  local vm=${1:-}
  local save=${2:-true}
  local result

  if [ ! -z "${vm}" ]; then
    if [ ! -z "${save}" ]; then
      vboxmanage controlvm ${vm} savestate
    fi
    vboxmanage controlvm ${vm} poweroff
    result=$(vbox::vms.running | egrep "${vm}")
  fi
  echo ${result:-null}
}

vbox::setup()
{
  local user=${1:-${USER:-$(whoami)}}

  addgroup ${user} vboxusers

  echo 'VBOXAUTOSTART_DB=/etc/vbox' > /etc/default/virtualbox
  echo 'VBOXAUTOSTART_CONFIG=/etc/vbox/autostartvm.cfg' >> /etc/default/virtualbox

  mkdir -p /etc/vbox
  chmod 1777 /etc/vbox

  echo 'default policy = deny' > /etc/vbox/autostartvm.cfg
  echo '' >> /etc/vbox/autostartvm.cfg
  echo "${user}= {" >> /etc/vbox/autostartvm.cfg
  echo '  allow = true' >> /etc/vbox/autostartvm.cfg
  echo '  startup_delay = 10' >> /etc/vbox/autostartvm.cfg
  echo '}' >> /etc/vbox/autostartvm.cfg

  touch /etc/vbox/${user}.start
  touch /etc/vbox/${user}.stop

  chgrp -R vboxusers /etc/vbox

  vboxmanage setproperty autostartdbpath /etc/vbox

  systemctl restart vboxautostart-service
}


