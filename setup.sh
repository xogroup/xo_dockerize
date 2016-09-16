#!/usr/bin/env bash
cd folder
filename=`curl -LOksS https://github.com/xogroup/xo_dockerize/archive/v1.0-beta.zip | find .zip`
echo $filename
#unzip $filename
