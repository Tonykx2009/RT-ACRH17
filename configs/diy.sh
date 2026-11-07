#!/bin/bash
# 将默认 LAN IP 从 192.168.1.1 改为 192.168.50.1
sed -i 's/192.168.1.1/192.168.50.1/g' package/base-files/files/bin/config_generate
