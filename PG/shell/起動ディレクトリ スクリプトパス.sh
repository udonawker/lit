#!/bin/sh

#スクリプトの絶対パス
readonly SCRIPT_PATH=$(cd $(dirname $0); pwd)/$(basename $0)
#スクリプト名
readonly SCRIPT_NAME=${0##*/} 
#スクリプトディレクトリ
readonly SCRIPT_DIR=`dirname ${0}`
