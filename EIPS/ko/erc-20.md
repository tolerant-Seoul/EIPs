---
eip: 20
title: 토큰 표준
author: Fabian Vogelsteller, Vitalik Buterin
status: Final
type: Standards Track
category: ERC
created: 2015-11-19
lang: ko
original: https://github.com/ethereum/ERCs/blob/master/ERCS/erc-20.md
---

## 요약

ERC-20은 스마트 컨트랙트 내 토큰 구현을 위한 통합 인터페이스를 수립합니다. 이 표준을 통해 토큰은 지갑과 탈중앙화 거래소에서 표준화된 기능으로 작동할 수 있습니다.

## 동기

표준 인터페이스를 통해 이더리움의 모든 토큰이 다른 애플리케이션(지갑, 탈중앙화 거래소 등)에서 재사용될 수 있습니다. 이는 생태계 전반의 상호운용성을 보장합니다.

## 명세

### 필수 메서드

#### `totalSupply()`
총 토큰 공급량을 반환합니다.

```solidity
function totalSupply() public view returns (uint256)
```

#### `balanceOf(address)`
특정 계정의 토큰 잔액을 반환합니다.

```solidity
function balanceOf(address _owner) public view returns (uint256 balance)
```

#### `transfer(address, uint256)`
토큰을 수신자에게 전송합니다.

```solidity
function transfer(address _to, uint256 _value) public returns (bool success)
```

- 호출자의 잔액이 부족하면 **반드시** 실패해야 함
- 값이 0인 전송도 일반 전송처럼 처리되어야 함
- `Transfer` 이벤트를 **반드시** 발생시켜야 함

#### `transferFrom(address, address, uint256)`
승인된 제3자가 토큰을 전송할 수 있게 합니다.

```solidity
function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
```

- 출금 워크플로우에 사용
- `_from` 계정이 호출자에게 명시적으로 승인한 경우에만 가능
- `Transfer` 이벤트를 **반드시** 발생시켜야 함

#### `approve(address, uint256)`
지출자에게 특정 금액의 출금 권한을 부여합니다.

```solidity
function approve(address _spender, uint256 _value) public returns (bool success)
```

- 호출 시 기존 허용량을 덮어씀
- `Approval` 이벤트를 **반드시** 발생시켜야 함

#### `allowance(address, address)`
지출자가 소유자로부터 출금할 수 있는 남은 금액을 반환합니다.

```solidity
function allowance(address _owner, address _spender) public view returns (uint256 remaining)
```

### 선택적 메서드 (사용성 향상)

#### `name()`
토큰의 이름을 반환합니다 (예: "MyToken").

```solidity
function name() public view returns (string)
```

#### `symbol()`
토큰의 심볼을 반환합니다 (예: "MTK").

```solidity
function symbol() public view returns (string)
```

#### `decimals()`
토큰의 소수점 자릿수를 반환합니다 (예: 18).

```solidity
function decimals() public view returns (uint8)
```

사용자 인터페이스 표시 목적으로 사용됩니다. 기본값 18을 권장합니다.

### 이벤트

#### `Transfer`
토큰이 전송될 때 **반드시** 발생해야 합니다 (값이 0인 경우 포함).

```solidity
event Transfer(address indexed _from, address indexed _to, uint256 _value)
```

새 토큰을 생성하는 토큰 컨트랙트는 `_from` 주소를 `0x0`으로 설정하여 `Transfer` 이벤트를 발생시켜야 합니다.

#### `Approval`
`approve(address _spender, uint256 _value)` 호출이 성공할 때 **반드시** 발생해야 합니다.

```solidity
event Approval(address indexed _owner, address indexed _spender, uint256 _value)
```

## 보안 고려사항

### 승인 경쟁 조건

`approve` 함수 사용 시 알려진 공격 벡터가 있습니다:

1. Alice가 Bob에게 N 토큰 승인
2. Alice가 승인을 M으로 변경하려고 시도
3. Bob이 트랜잭션 순서를 조작하여 N+M 토큰을 출금할 수 있음

**권장 해결책**: 허용량을 변경하기 전에 먼저 0으로 설정한 후 원하는 값으로 설정합니다. 그러나 스마트 컨트랙트 자체는 역호환성을 위해 이를 강제하지 않아야 합니다.

## 구현 예시

OpenZeppelin과 ConsenSys에서 참조 구현을 제공하며, 다양한 최적화 접근 방식을 사용할 수 있습니다.

## 역호환성

많은 토큰이 이미 배포되어 있으며, 대부분 이 명세를 지원합니다.

## 저작권

저작권 및 관련 권리는 CC0를 통해 포기되었습니다.
