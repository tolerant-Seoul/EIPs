#!/bin/bash
# EIP 번역 상태 확인 스크립트
# 사용법: ./scripts/check-translation-status.sh

set -e

EIPS_DIR="EIPS"
KO_DIR="EIPS/ko"

echo "=========================================="
echo "EIP 한국어 번역 상태 확인"
echo "=========================================="
echo ""

# 번역 완료된 EIP 수
translated_count=$(ls -1 "$KO_DIR"/*.md 2>/dev/null | grep -v README | wc -l | tr -d ' ')
echo "✅ 번역 완료: ${translated_count}개"
echo ""

# 번역된 EIP 목록
echo "📋 번역된 EIP 목록:"
for file in "$KO_DIR"/eip-*.md; do
    if [ -f "$file" ]; then
        eip_num=$(basename "$file" .md | sed 's/eip-//')
        title=$(grep -m1 "^title:" "$file" | sed 's/title: //')
        echo "   - EIP-${eip_num}: ${title}"
    fi
done
echo ""

# Final 상태의 미번역 Core EIP 확인
echo "=========================================="
echo "🔴 미번역 Final Core EIPs (우선 번역 대상):"
echo "=========================================="

for file in "$EIPS_DIR"/eip-*.md; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        eip_num=$(echo "$filename" | sed 's/eip-\([0-9]*\)\.md/\1/')

        # ko 디렉토리에 번역본이 없는 경우
        if [ ! -f "$KO_DIR/$filename" ]; then
            # Final 상태이고 Core 카테고리인 경우
            status=$(grep -m1 "^status:" "$file" 2>/dev/null | sed 's/status: //')
            category=$(grep -m1 "^category:" "$file" 2>/dev/null | sed 's/category: //')

            if [ "$status" = "Final" ] && [ "$category" = "Core" ]; then
                title=$(grep -m1 "^title:" "$file" | sed 's/title: //')
                echo "   EIP-${eip_num}: ${title}"
            fi
        fi
    fi
done
echo ""

# Final 상태의 미번역 Interface EIP 확인
echo "=========================================="
echo "🟡 미번역 Final Interface EIPs:"
echo "=========================================="

for file in "$EIPS_DIR"/eip-*.md; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        eip_num=$(echo "$filename" | sed 's/eip-\([0-9]*\)\.md/\1/')

        if [ ! -f "$KO_DIR/$filename" ]; then
            status=$(grep -m1 "^status:" "$file" 2>/dev/null | sed 's/status: //')
            category=$(grep -m1 "^category:" "$file" 2>/dev/null | sed 's/category: //')

            if [ "$status" = "Final" ] && [ "$category" = "Interface" ]; then
                title=$(grep -m1 "^title:" "$file" | sed 's/title: //')
                echo "   EIP-${eip_num}: ${title}"
            fi
        fi
    fi
done
echo ""

# Upstream 비교 (upstream이 설정된 경우)
if git remote | grep -q upstream; then
    echo "=========================================="
    echo "🆕 Upstream 대비 새로운 EIP:"
    echo "=========================================="

    git fetch upstream --quiet 2>/dev/null || true
    new_eips=$(git diff HEAD upstream/master --name-only -- "EIPS/eip-*.md" 2>/dev/null | head -10)

    if [ -n "$new_eips" ]; then
        echo "$new_eips"
    else
        echo "   새로운 EIP 없음 (또는 upstream 동기화 필요)"
    fi
else
    echo "💡 Tip: upstream 원격 저장소를 추가하면 새 EIP를 확인할 수 있습니다:"
    echo "   git remote add upstream https://github.com/ethereum/EIPs.git"
fi

echo ""
echo "=========================================="
echo "완료"
echo "=========================================="
