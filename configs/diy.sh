#!/bin/bash
# 将默认 LAN IP 从 192.168.1.1 改为 192.168.50.1
# sed -i 's/192.168.1.1/192.168.50.1/g' package/base-files/files/bin/config_generate
#!/bin/bash

# 1. 设置 LAN IP (使用 DSA 感知的方式，确保配置生效)
cat > package/base-files/files/etc/config/network <<'EOF'
config interface 'loopback'
    option device 'lo'
    option proto 'static'
    option ipaddr '127.0.0.1'
    option netmask '255.0.0.0'

config interface 'lan'
    option device 'br-lan'
    option proto 'static'
    option ipaddr '192.168.50.1'
    option netmask '255.255.255.0'

config interface 'wan'
    option device 'wan'
    option proto 'dhcp'
EOF

# 2. 关键：修改设备定义，让 sysupgrade 元数据包含 RT-ACRH17 别名
# 在 ipq40xx 的 generic.mk 中，为 asus_rt-ac42u 显式添加别名
sed -i '/define Device\/asus_rt-ac42u/,/endef/ {
    /SUPPORTED_DEVICES/d
    /TARGET_DEVICES/a\  SUPPORTED_DEVICES += asus,rt-acrh17
}' target/linux/ipq40xx/image/generic.mk
