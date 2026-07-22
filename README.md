# domain-lists

本项目利用 GitHub Actions 自动抓取 GEOSITE 数据库来生成满足特定条件的域名列表, 可用于 VPN 分流

- 主数据源:[blackmatrix7/ios_rule_script](https://github.com/blackmatrix7/ios_rule_script)(`rule/Clash/<分类>/<分类>.list`),按服务单独维护, 粒度比 geosite 大类精细很多 (比如 `TencentVideo` 只含 v.qq.com 相关域名,不含 QQ/微信/腾讯云)
- 补充数据源:[MetaCubeX/meta-rules-dat](https://github.com/MetaCubeX/meta-rules-dat)(`meta` 分支 `geo/geosite/*.list`),仅用于 bm7 没有对应分类的服务(QQ音乐+喜马拉雅、华数 IPTV)
- 输出: `lists/china-streaming-domains.list`,一行一个域名(已去除 `DOMAIN-SUFFIX,`/`+.` 等前缀,只保留域名/后缀域名,丢弃 IP-CIDR)
- 更新: GitHub Actions 每天 UTC 07:00(美东时间 03:00, 北京时间当日 15:00) 自动拉取并提交, 也可在 Actions 页手动 `Run workflow`

### 中国流媒体域名列表

每天自动生成一份「中国大陆流媒体(视频/音乐)」域名列表:
```
https://raw.githubusercontent.com/KervynH/domain-lists/main/lists/china-streaming-domains.list
```

目前覆盖的服务: 哔哩哔哩、爱奇艺、优酷、腾讯视频、搜狐视频、PPTV、芒果TV/湖南卫视、央视网、百视通、华数、网易云音乐、酷狗/酷我、QQ音乐、喜马拉雅、咪咕 
(注: `Sohu` 分类里带了畅游/17173 等搜狐旗下游戏域名,不是纯视频)

增减覆盖的网站的方法: 修改 `scripts/build-china-streaming-domains.sh` 里的 `BM7_CATEGORIES` / `GEOSITE_CATEGORIES` 数组即可
- bm7 分类名对应 [rule/Clash 目录](https://github.com/blackmatrix7/ios_rule_script/tree/master/rule/Clash)下的子目录名
- geosite 分类名对应 [geo/geosite 目录](https://github.com/MetaCubeX/meta-rules-dat/tree/meta/geo/geosite)下的文件名(去掉 `.list` 后缀)
