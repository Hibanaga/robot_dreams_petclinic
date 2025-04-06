#!/bin/bash

set -e

apt-get -y update

function yell {
  echo "🔊 $(date +"%T") $1"
}

function setupPackage {
    if (dpkg -l $1); then
      yell "✅  Initialize update $1 package";
      apt-get -y --only-upgrade install $1
      yell "✅  $1 successfully updated";
    else
      yell "🚀 Initialize install $1 package"
      apt-get -y install $1
      yell "🚀 $1 installed successfully"
    fi
}

for package in 'abc' 'nginx' 'curl' 'apache2' 'ufw' 'postgresql';
do
  if (apt-cache show $package &>/dev/null); then
    setupPackage $package
  else
    yell "❌ Package $package doesn't exists. Skipping..."
  fi;
done

yell "🎉 Configuration setup ended successfully"