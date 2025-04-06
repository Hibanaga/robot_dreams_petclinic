#!/bin/bash

set -e

apt-get -y update

function yell {
  echo "🔊 $(date +"%T") $1"
}

for package in 'nginx' 'curl' 'apache2' 'ufw' 'postgresql';
do
  if (dpkg -l $package); then
    yell "✅ Initialize update $package package";
    apt-get -y --only-upgrade install $package
    yell "✅ $package successfully updated";
  else
    yell "🚀 Initialize install $package package"
    apt-get -y install $package
    yell "🚀 $package installed successfully"
  fi
done

yell "🎉 Configuration setup ended successfully"