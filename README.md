# streaming-domains

每天自动生成一份「中国大陆流媒体(视频/音乐)」域名列表 —— 这些站点在海外访问会被地区限制,需要走国内节点。供身处海外的用户在路由器(如 GL.iNet)的 VPN 策略里做反向分流(命中这些域名 = 走国内节点,而不是走代理)。

- 主数据源:[blackmatrix7/ios_rule_script](https://github.com/blackmatrix7/ios_rule_script)(`rule/Clash/<分类>/<分类>.list`),按服务单独维护,粒度比 geosite 大类精细很多(比如 `TencentVideo` 只含 v.qq.com 相关域名,不含 QQ/微信/腾讯云)
- 补充数据源:[MetaCubeX/meta-rules-dat](https://github.com/MetaCubeX/meta-rules-dat)(`meta` 分支 `geo/geosite/*.list`),仅用于 bm7 没有对应分类的服务(QQ音乐+喜马拉雅、华数 IPTV)
- 覆盖:哔哩哔哩、爱奇艺、优酷、腾讯视频(仅 v.qq.com,不含 QQ/微信)、搜狐视频、PPTV、芒果TV/湖南卫视、央视网、百视通、华数、网易云音乐、酷狗/酷我、QQ音乐、喜马拉雅、咪咕
- 输出:`lists/china-streaming-domains.list`,一行一个域名(已去除 `DOMAIN-SUFFIX,`/`+.` 等前缀,只保留域名/后缀域名,丢弃 IP-CIDR)
- 更新:GitHub Actions 每天 UTC 19:00(北京时间次日 03:00)自动拉取并提交,也可在 Actions 页手动 `Run workflow`

## 使用方式

路由器可直接订阅这个原始文件地址(替换成你自己仓库的路径):

```
https://raw.githubusercontent.com/<your-username>/streaming-domains/main/lists/china-streaming-domains.list
```

## 已知局限

- `Sohu` 分类里带了畅游/17173 等搜狐旗下游戏域名,不是纯视频。
- QQ音乐/喜马拉雅没有单独的 bm7 分类,用的是 geosite 的 `tencent-tme`(只含音乐/音频域名,不含 QQ/微信等)。

## 增减服务

编辑 `scripts/build-china-streaming-domains.sh` 里的 `BM7_CATEGORIES` / `GEOSITE_CATEGORIES` 数组即可。
- bm7 分类名对应 [rule/Clash 目录](https://github.com/blackmatrix7/ios_rule_script/tree/master/rule/Clash)下的子目录名
- geosite 分类名对应 [geo/geosite 目录](https://github.com/MetaCubeX/meta-rules-dat/tree/meta/geo/geosite)下的文件名(去掉 `.list` 后缀)
