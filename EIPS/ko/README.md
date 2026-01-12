# EIP 한국어 번역 프로젝트

이 디렉토리는 Ethereum Improvement Proposals (EIPs)의 한국어 번역을 포함합니다.

## 번역 현황

### 번역 완료 (32개)

#### Core EIPs (12개)

| EIP | 제목 | 하드포크 | 상태 |
|-----|------|----------|------|
| [EIP-155](./eip-155.md) | 단순 재전송 공격 보호 | Spurious Dragon | Final |
| [EIP-1559](./eip-1559.md) | 수수료 시장 변경 | London | Final |
| [EIP-2718](./eip-2718.md) | 타입화된 트랜잭션 엔벨로프 | Berlin | Final |
| [EIP-2929](./eip-2929.md) | 상태 접근 가스 비용 증가 | Berlin | Final |
| [EIP-2930](./eip-2930.md) | 선택적 접근 목록 | Berlin | Final |
| [EIP-3198](./eip-3198.md) | BASEFEE 옵코드 | London | Final |
| [EIP-3529](./eip-3529.md) | 환불 감소 | London | Final |
| [EIP-3675](./eip-3675.md) | 지분 증명으로 업그레이드 | The Merge | Final |
| [EIP-4844](./eip-4844.md) | 샤드 블롭 트랜잭션 | Dencun | Final |
| [EIP-4895](./eip-4895.md) | 비콘 체인 푸시 출금 | Shanghai | Final |
| [EIP-6780](./eip-6780.md) | SELFDESTRUCT 제한 | Cancun | Final |
| [EIP-7702](./eip-7702.md) | EOA 코드 설정 | Pectra | Final |

#### Interface EIPs (3개)

| EIP | 제목 | 상태 |
|-----|------|------|
| [EIP-712](./eip-712.md) | 타입화된 구조화 데이터 서명 | Final |
| [EIP-1193](./eip-1193.md) | 이더리움 프로바이더 JavaScript API | Final |
| [EIP-6963](./eip-6963.md) | 다중 주입 프로바이더 발견 | Final |

#### Networking EIPs (3개)

| EIP | 제목 | 상태 |
|-----|------|------|
| [EIP-8](./eip-8.md) | devp2p 전방 호환성 | Final |
| [EIP-778](./eip-778.md) | 이더리움 노드 레코드 (ENR) | Final |
| [EIP-2124](./eip-2124.md) | 포크 식별자 | Final |

#### Meta / Informational EIPs (3개)

| EIP | 제목 | 카테고리 | 상태 |
|-----|------|----------|------|
| [EIP-1](./eip-1.md) | EIP 목적과 가이드라인 | Meta | Living |
| [EIP-4](./eip-4.md) | EIP 분류 | Meta | Final |
| [EIP-2982](./eip-2982.md) | Serenity Phase 0 | Informational | Final |

#### ERCs - 토큰 표준 (4개)

| ERC | 제목 | 상태 |
|-----|------|------|
| [ERC-20](./erc-20.md) | 토큰 표준 | Final |
| [ERC-165](./erc-165.md) | 표준 인터페이스 감지 | Final |
| [ERC-721](./erc-721.md) | 대체 불가능 토큰 (NFT) 표준 | Final |
| [ERC-1155](./erc-1155.md) | 멀티 토큰 표준 | Final |

#### ERCs - 계정 추상화 (3개)

| ERC | 제목 | 상태 |
|-----|------|------|
| [ERC-4337](./erc-4337.md) | 계정 추상화 (EntryPoint) | Final |
| [ERC-6900](./erc-6900.md) | 모듈러 스마트 컨트랙트 계정 | Draft |
| [ERC-7579](./erc-7579.md) | 최소 모듈러 스마트 계정 | Draft |

#### ERCs - 프라이버시 (2개)

| ERC | 제목 | 상태 |
|-----|------|------|
| [ERC-5564](./erc-5564.md) | 스텔스 주소 | Final |
| [ERC-6538](./erc-6538.md) | 스텔스 메타 주소 레지스트리 | Final |

#### ERCs - 기타 (2개)

| ERC | 제목 | 상태 |
|-----|------|------|
| [ERC-191](./erc-191.md) | 서명 데이터 표준 | Final |
| [ERC-1337](./erc-1337.md) | 블록체인 구독 | Stagnant |

### 번역 우선순위 (미번역)

#### 높은 우선순위
- [ ] EIP-7516 - BLOBBASEFEE opcode (Dencun)
- [ ] EIP-1014 - Skinny CREATE2
- [ ] EIP-1052 - EXTCODEHASH opcode
- [ ] ERC-2981 - NFT 로열티 표준

#### 중간 우선순위
- [ ] EIP-2 - Homestead Hard-fork Changes
- [ ] EIP-7 - DELEGATECALL
- [ ] EIP-150 - Gas cost changes for IO-heavy operations
- [ ] EIP-161 - State trie clearing

## Upstream 동기화 방법

```bash
# 1. upstream 원격 저장소 추가 (최초 1회)
git remote add upstream https://github.com/ethereum/EIPs.git

# 2. upstream 변경사항 가져오기
git fetch upstream

# 3. 새로운/변경된 EIP 확인
git diff upstream/master --stat -- EIPS/*.md

# 4. 새로운 Final/Living EIP 목록 확인
git diff upstream/master --name-only -- EIPS/*.md | head -20

# 5. 병합 (충돌 해결 필요시 수동)
git merge upstream/master
```

## 새로운 EIP 번역 시 체크리스트

1. [ ] 원본 EIP 읽기 및 이해
2. [ ] `EIPS/ko/eip-XXXX.md` 파일 생성
3. [ ] YAML frontmatter에 `lang: ko` 및 `original:` 추가
4. [ ] 기술 용어는 영어 유지, 필요시 한글 설명 병기
5. [ ] 코드 블록은 원본 유지 (주석만 번역)
6. [ ] 이 README.md의 번역 현황 업데이트

## 번역 규칙

### 용어 번역 기준
| 영어 | 한국어 |
|------|--------|
| Transaction | 트랜잭션 |
| Block | 블록 |
| Gas | 가스 |
| Smart Contract | 스마트 컨트랙트 |
| Proof of Work | 작업 증명 |
| Proof of Stake | 지분 증명 |
| Validator | 검증자 |
| Beacon Chain | 비콘 체인 |
| Fork | 포크/하드포크 |
| Opcode | 옵코드 |
| EVM | EVM (이더리움 가상 머신) |
| Blob | 블롭 |
| Token | 토큰 |
| NFT | NFT (대체 불가능 토큰) |
| Account Abstraction | 계정 추상화 |
| Stealth Address | 스텔스 주소 |

### YAML Frontmatter 형식
```yaml
---
eip: XXXX
title: 한국어 제목
description: 한국어 설명
author: 원본 저자 (원본 유지)
status: Final
type: Standards Track
category: Core
created: YYYY-MM-DD
lang: ko
original: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-XXXX.md
---
```

## 기여 방법

1. 이 저장소를 Fork
2. 번역할 EIP 선택 (위 우선순위 참고)
3. 번역 후 Pull Request 생성
4. 리뷰 후 병합

## 라이선스

원본 EIP와 동일하게 [CC0](../LICENSE.md) 라이선스를 따릅니다.
