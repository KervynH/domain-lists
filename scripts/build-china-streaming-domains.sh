#!/usr/bin/env bash
set -euo pipefail

OUT="lists/china-streaming-domains.list"

# 主数据源:blackmatrix7/ios_rule_script,按服务单独维护的 Clash 规则列表(DOMAIN,/DOMAIN-SUFFIX,/IP-CIDR,...)
# 比 geosite 的大类精细得多(比如 TencentVideo 只有 v.qq.com 相关域名,不含 QQ/微信/腾讯云)
BM7_BASE="https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Clash"
BM7_CATEGORIES=(
  # 视频
  BiliBili
  iQIYI
  Youku
  TencentVideo
  Sohu
  PPTV
  HunanTV   # 芒果TV/湖南卫视
  CCTV
  BesTV     # 百视通 IPTV
  Migu      # 咪咕视频
  # 音乐
  NetEaseMusic
  KugouKuwo
)

# 补充数据源:geosite(MetaCubeX/meta-rules-dat),仅用于 bm7 没有的类目
# tencent-tme = QQ音乐 + 喜马拉雅(顺带酷狗酷我,和上面重复无妨,去重即可)
GEOSITE_BASE="https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite"
GEOSITE_CATEGORIES=(
  tencent-tme
  wasu # 华数 IPTV,bm7 没有对应分类
)

mkdir -p "$(dirname "$OUT")"
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

fail=0

for c in "${BM7_CATEGORIES[@]}"; do
  if ! curl -fsSL --retry 3 "${BM7_BASE}/${c}/${c}.list" \
      | grep -E '^(DOMAIN|DOMAIN-SUFFIX),' \
      | sed -E 's/^(DOMAIN|DOMAIN-SUFFIX),//' \
      >> "$tmp"; then
    echo "警告: ${c} 拉取失败,跳过" >&2
    fail=1
  fi
done

for c in "${GEOSITE_CATEGORIES[@]}"; do
  if ! curl -fsSL --retry 3 "${GEOSITE_BASE}/${c}.list" \
      | grep -viE '^(regexp|keyword):' \
      | sed -E 's/^\+\.//' \
      >> "$tmp"; then
    echo "警告: ${c} 拉取失败,跳过" >&2
    fail=1
  fi
  # 源文件末尾不一定有换行符,拼接前补一个,避免和下一个文件的第一行粘连
  printf '\n' >> "$tmp"
done

grep -v '^\s*#' "$tmp" \
  | grep -v '^\s*$' \
  | tr 'A-Z' 'a-z' \
  | sort -u > "$OUT"

count=$(wc -l < "$OUT" | tr -d ' ')
echo "生成 ${count} 条域名 -> ${OUT}"

if [ "$count" -lt 100 ]; then
  echo "错误: 生成的域名数量异常偏少($count),疑似拉取大面积失败,放弃本次更新" >&2
  exit 1
fi

exit "$fail"
