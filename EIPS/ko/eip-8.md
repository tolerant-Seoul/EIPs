---
eip: 8
title: 홈스테드를 위한 devp2p 순방향 호환성 요구사항
author: Felix Lange <felix@ethdev.com>
status: Final
type: Standards Track
category: Networking
created: 2015-12-18
lang: ko
original: ../eip-8.md
---

### 요약

이 EIP는 devp2p 와이어 프로토콜, RLPx 발견 프로토콜, RLPx TCP 전송 프로토콜의 구현에 대한 새로운 순방향 호환성 요구사항을 도입합니다. EIP-8을 구현하는 클라이언트는 포스텔의 법칙(Postel's Law)에 따라 동작합니다:

> 보내는 것은 보수적으로, 받는 것은 관대하게.

### 명세

**devp2p 와이어 프로토콜**의 구현체는 hello 패킷의 버전 번호를 무시해야 합니다. hello 패킷을 보낼 때, 버전 요소는 지원되는 가장 높은 devp2p 버전으로 설정해야 합니다. 구현체는 또한 hello 패킷 끝에 있는 추가 목록 요소를 무시해야 합니다.

마찬가지로, **RLPx 발견 프로토콜**의 구현체는 ping 패킷의 버전 번호를 검증하지 않아야 하고, 모든 패킷의 추가 목록 요소를 무시해야 하며, 모든 패킷에서 첫 번째 RLP 값 이후의 데이터를 무시해야 합니다. 알 수 없는 패킷 유형의 발견 패킷은 조용히 폐기해야 합니다. 모든 발견 패킷의 최대 크기는 여전히 1280바이트입니다.

마지막으로, **RLPx TCP 전송 프로토콜**의 구현체는 암호화된 키 설정 핸드셰이크 패킷의 새 인코딩을 수락해야 합니다. EIP-8 스타일의 RLPx `auth-packet`을 수신하면, 해당하는 `ack-packet`은 아래 규칙을 사용하여 전송해야 합니다.

`auth-body`와 `ack-body`의 RLP 데이터를 디코딩할 때 `auth-vsn`과 `ack-vsn`의 불일치, 추가 목록 요소, 목록 이후의 후행 데이터를 무시해야 합니다. 전환 기간 동안(즉, 이전 포맷이 폐지될 때까지), 구현체는 `auth-body`에 최소 100바이트의 정크 데이터를 패딩해야 합니다. 패킷 크기를 다양하게 하기 위해 [100, 300] 범위의 임의의 양을 추가하는 것이 권장됩니다.

```text
auth-vsn         = 4
auth-size        = enc-auth-body의 크기, 빅 엔디언 16비트 정수로 인코딩
auth-body        = rlp.list(sig, initiator-pubk, initiator-nonce, auth-vsn)
enc-auth-body    = ecies.encrypt(recipient-pubk, auth-body, auth-size)
auth-packet      = auth-size || enc-auth-body

ack-vsn          = 4
ack-size         = enc-ack-body의 크기, 빅 엔디언 16비트 정수로 인코딩
ack-body         = rlp.list(recipient-ephemeral-pubk, recipient-nonce, ack-vsn)
enc-ack-body     = ecies.encrypt(initiator-pubk, ack-body, ack-size)
ack-packet       = ack-size || enc-ack-body

여기서

X || Y
    X와 Y의 연결을 나타냅니다.
X[:N]
    X의 N바이트 접두사를 나타냅니다.
rlp.list(X, Y, Z, ...)
    [X, Y, Z, ...]를 RLP 목록으로 재귀적 인코딩함을 나타냅니다.
sha3(MESSAGE)
    이더리움에서 사용하는 Keccak256 해시 함수입니다.
ecies.encrypt(PUBKEY, MESSAGE, AUTHDATA)
    RLPx에서 사용하는 비대칭 인증 암호화 함수입니다.
    AUTHDATA는 결과 암호문의 일부가 아닌 인증 데이터이지만,
    메시지 태그를 생성하기 전에 HMAC-256에 기록됩니다.
```

### 동기

devp2p 프로토콜의 변경은 배포하기 어렵습니다. 이전 버전을 실행하는 클라이언트는 hello(발견 ping, RLPx 핸드셰이크) 패킷의 버전 번호나 구조가 로컬 기대와 일치하지 않으면 통신을 거부하기 때문입니다.

홈스테드 합의 업그레이드의 일부로 순방향 호환성 요구사항을 도입하면, 이더리움 네트워크에서 사용 중인 모든 클라이언트 소프트웨어가 향후 네트워크 프로토콜 업그레이드에 대처할 수 있게 됩니다(역호환성이 유지되는 한).

### 근거

제안된 변경사항은 프로토콜 스택 전체에 포스텔의 법칙(견고성 원칙으로도 알려짐)을 적용하여 순방향 호환성을 다룹니다. 이 접근 방식의 장점과 적용 가능성은 RFC 761에서의 최초 적용 이후 반복적으로 연구되었습니다. 최근 관점은 ["The Robustness Principle Reconsidered" (Eric Allman, 2011)](https://queue.acm.org/detail.cfm?id=1999945)를 참조하세요.

#### devp2p 와이어 프로토콜 변경사항

현재 모든 클라이언트는 다음과 같은 구문을 포함합니다:

```python
# pydevp2p/p2p_protocol.py
if data['version'] != proto.version:
    log.debug('incompatible network protocols', peer=proto.peer,
        expected=proto.version, received=data['version'])
    return proto.send_disconnect(reason=reasons.incompatible_p2p_version)
```

이러한 검사는 hello 패킷의 버전이나 구조를 변경하는 것을 불가능하게 만듭니다. 이를 제거하면 더 새로운 프로토콜 버전으로 전환할 수 있게 됩니다: 더 새로운 버전을 구현하는 클라이언트는 단순히 더 높은 버전과 추가 목록 요소가 있는 패킷을 보냅니다.

* 이러한 패킷을 더 낮은 버전의 노드가 수신하면, 원격 끝이 역호환된다고 맹목적으로 가정하고 이전 핸드셰이크로 응답합니다.
* 동일한 버전의 노드가 패킷을 수신하면, 프로토콜의 새 기능을 사용할 수 있습니다.
* 더 높은 버전의 노드가 패킷을 수신하면, 역호환성 로직을 활성화하거나 연결을 끊을 수 있습니다.

#### RLPx 발견 프로토콜 변경사항

발견 패킷 디코딩 규칙의 완화는 대체로 현재 관행을 성문화합니다. 대부분의 기존 구현체는 목록 요소의 수에 관심이 없고(예외는 go-ethereum) 버전이 일치하지 않는 노드를 거부하지 않습니다. 그러나 이 동작은 명세로 보장되지 않습니다.

채택되면, 이 변경은 devp2p hello 변경과 유사한 방식으로 프로토콜 변경을 배포할 수 있게 합니다: 단순히 버전을 올리고 추가 정보를 보냅니다. 이전 클라이언트는 추가 요소를 무시하고 네트워크의 대다수가 더 새로운 프로토콜로 이동한 후에도 계속 작동할 수 있습니다.

#### RLPx TCP 핸드셰이크 변경사항

RLPx v5 변경(청크 패킷, 키 파생 변경)에 대한 논의는 부분적으로 v4 핸드셰이크 인코딩이 버전 번호를 추가하는 단 하나의 인밴드 방법만 제공하기 때문에 중단되었습니다: 논스의 랜덤 부분을 줄이는 것. RLPx v5 핸드셰이크 제안이 수락되더라도, 핸드셰이크 패킷이 알려진 레이아웃의 고정 크기 ECIES 암호문이기 때문에 향후 업그레이드가 어렵습니다.

핸드셰이크 패킷에 다음 변경을 제안합니다:

* 암호문 길이를 평문 헤더로 추가.
* 핸드셰이크 본문을 RLP로 인코딩.
* 토큰 플래그(미사용) 대신 두 패킷 모두에 버전 번호 추가.
* 임시 공개키의 해시 제거(중복됨).

이러한 변경은 다른 프로토콜에 대해 설명한 것과 동일한 방식으로 RLPx TCP 전송 프로토콜을 업그레이드할 수 있게 합니다. 즉, 목록 요소를 추가하고 버전을 올리는 것입니다. 이것이 RLPx 핸드셰이크 패킷의 첫 번째 변경이므로, 현재 사용하지 않는 모든 필드를 제거할 기회로 삼을 수 있습니다.

핸드셰이크 패킷이 이전 포맷과 구별되려면 크기가 커져야 하므로 RLP 목록 이후의 추가 데이터가 허용됩니다(사실 필수입니다). 클라이언트는 두 포맷을 동시에 처리하기 위해 다음 의사 코드와 같은 로직을 사용할 수 있습니다.

```go
packet = read(307, connection)
if decrypt(packet) {
    // 이전 포맷으로 처리
} else {
    size = unpack_16bit_big_endian(packet)
    packet += read(size - 307 + 2, connection)
    if !decrypt(packet) {
        // 오류
    }
    // 새 포맷으로 처리
}
```

평문 크기 접두사는 아마도 이 문서에서 가장 논쟁적인 부분일 것입니다. 접두사가 네트워크 수준에서 RLPx 연결을 필터링하고 식별하려는 적대자를 돕는다는 주장이 있었습니다.

이것은 대체로 적대자가 얼마나 많은 노력을 기울일 의향이 있는지의 문제입니다. 길이를 무작위화하라는 권장 사항을 따르면, 순수 패턴 기반 패킷 인식은 성공하기 어려울 것입니다.

* 일반적인 방화벽 운영자에게, 처음 2바이트가 [300,600] 범위의 정수를 형성하는 모든 연결을 차단하는 것은 아마도 너무 침습적일 것입니다. 포트 기반 차단이 대부분의 RLPx 트래픽을 필터링하는 더 효과적인 조치가 될 것입니다.
* 많은 기준을 상관시킬 수 있는 공격자에게, 크기 접두사는 지표 세트에 추가되므로 인식을 용이하게 할 것입니다. 그러나 그러한 공격자는 RLPx 발견 트래픽을 읽거나 참여할 수도 있을 것으로 예상되며, 이는 포맷이 무엇이든 RLPx TCP 연결 차단을 가능하게 하기에 충분할 것입니다.

### 역호환성

이 EIP는 역호환됩니다. 모든 유효한 버전 4 패킷은 여전히 수락됩니다.

### 구현

[go-ethereum](https://github.com/ethereum/go-ethereum/pull/2091)
[libweb3core](https://github.com/ethereum/libweb3core/pull/46)
[pydevp2p](https://github.com/ethereum/pydevp2p/pull/32)

### 테스트 벡터

#### devp2p 기본 프로토콜

버전 22를 광고하고 몇 가지 추가 목록 요소를 포함하는 devp2p hello 패킷:

```text
f87137916b6e6574682f76302e39312f706c616e39cdc5836574683dc6846d6f726b1682270fb840
fda1cff674c90c9a197539fe3dfb53086ace64f83ed7c6eabec741f7f381cc803e52ab2cd55d5569
bce4347107a310dfd5f88a010cd2ffd1005ca406f1842877c883666f6f836261720304
```

#### RLPx 발견 프로토콜

구현체는 다음 인코딩된 발견 패킷을 유효한 것으로 수락해야 합니다.
패킷은 secp256k1 노드 키로 서명됩니다.

```text
b71c71a67e1177ad4e901695e1b4b9ee17ae16c6668d313eac2f96dbcda3f291
```

버전 4, 추가 목록 요소가 있는 ping 패킷:

```text
e9614ccfd9fc3e74360018522d30e1419a143407ffcce748de3e22116b7e8dc92ff74788c0b6663a
aa3d67d641936511c8f8d6ad8698b820a7cf9e1be7155e9a241f556658c55428ec0563514365799a
4be2be5a685a80971ddcfa80cb422cdd0101ec04cb847f000001820cfa8215a8d790000000000000
000000000000000000018208ae820d058443b9a3550102
```

버전 555, 추가 목록 요소와 추가 랜덤 데이터가 있는 ping 패킷:

```text
577be4349c4dd26768081f58de4c6f375a7a22f3f7adda654d1428637412c3d7fe917cadc56d4e5e
7ffae1dbe3efffb9849feb71b262de37977e7c7a44e677295680e9e38ab26bee2fcbae207fba3ff3
d74069a50b902a82c9903ed37cc993c50001f83e82022bd79020010db83c4d001500000000abcdef
12820cfa8215a8d79020010db885a308d313198a2e037073488208ae82823a8443b9a355c5010203
040531b9019afde696e582a78fa8d95ea13ce3297d4afb8ba6433e4154caa5ac6431af1b80ba7602
3fa4090c408f6b4bc3701562c031041d4702971d102c9ab7fa5eed4cd6bab8f7af956f7d565ee191
7084a95398b6a21eac920fe3dd1345ec0a7ef39367ee69ddf092cbfe5b93e5e568ebc491983c09c7
6d922dc3
```

추가 목록 요소와 추가 랜덤 데이터가 있는 pong 패킷:

```text
09b2428d83348d27cdf7064ad9024f526cebc19e4958f0fdad87c15eb598dd61d08423e0bf66b206
9869e1724125f820d851c136684082774f870e614d95a2855d000f05d1648b2d5945470bc187c2d2
216fbe870f43ed0909009882e176a46b0102f846d79020010db885a308d313198a2e037073488208
ae82823aa0fbc914b16819237dcd8801d7e53f69e9719adecb3cc0e790c57e91ca4461c9548443b9
a355c6010203c2040506a0c969a58f6f9095004c0177a6b47f451530cab38966a25cca5cb58f0555
42124e
```

추가 목록 요소와 추가 랜덤 데이터가 있는 findnode 패킷:

```text
c7c44041b9f7c7e41934417ebac9a8e1a4c6298f74553f2fcfdcae6ed6fe53163eb3d2b52e39fe91
831b8a927bf4fc222c3902202027e5e9eb812195f95d20061ef5cd31d502e47ecb61183f74a504fe
04c51e73df81f25c4d506b26db4517490103f84eb840ca634cae0d49acb401d8a4c6b6fe8c55b70d
115bf400769cc1400f3258cd31387574077f301b421bc84df7266c44e9e6d569fc56be0081290476
7bf5ccd1fc7f8443b9a35582999983999999280dc62cc8255c73471e0a61da0c89acdc0e035e260a
dd7fc0c04ad9ebf3919644c91cb247affc82b69bd2ca235c71eab8e49737c937a2c396
```

추가 목록 요소와 추가 랜덤 데이터가 있는 neighbours 패킷:

```text
c679fc8fe0b8b12f06577f2e802d34f6fa257e6137a995f6f4cbfc9ee50ed3710faf6e66f932c4c8
d81d64343f429651328758b47d3dbc02c4042f0fff6946a50f4a49037a72bb550f3a7872363a83e1
b9ee6469856c24eb4ef80b7535bcf99c0004f9015bf90150f84d846321163782115c82115db84031
55e1427f85f10a5c9a7755877748041af1bcd8d474ec065eb33df57a97babf54bfd2103575fa8291
15d224c523596b401065a97f74010610fce76382c0bf32f84984010203040101b840312c55512422
cf9b8a4097e9a6ad79402e87a15ae909a4bfefa22398f03d20951933beea1e4dfa6f968212385e82
9f04c2d314fc2d4e255e0d3bc08792b069dbf8599020010db83c4d001500000000abcdef12820d05
820d05b84038643200b172dcfef857492156971f0e6aa2c538d8b74010f8e140811d53b98c765dd2
d96126051913f44582e8c199ad7c6d6819e9a56483f637feaac9448aacf8599020010db885a308d3
13198a2e037073488203e78203e8b8408dcab8618c3253b558d459da53bd8fa68935a719aff8b811
197101a4b2b47dd2d47295286fc00cc081bb542d760717d1bdd6bec2c37cd72eca367d6dd3b9df73
8443b9a355010203b525a138aa34383fec3d2719a0
```

#### RLPx 핸드셰이크

이 테스트 벡터에서, 노드 A가 노드 B와의 연결을 시작합니다.
모든 패킷에 포함된 값은 아래와 같습니다:

```text
Static Key A:    49a7b37aa6f6645917e7b807e9d1c00d4fa71f18343b0d4122a4d2df64dd6fee
Static Key B:    b71c71a67e1177ad4e901695e1b4b9ee17ae16c6668d313eac2f96dbcda3f291
Ephemeral Key A: 869d6ecf5211f1cc60418a13b9d870b22959d0c16f02bec714c960dd2298a32d
Ephemeral Key B: e238eb8e04fee6511ab04c6dd3c89ce097b11f25d584863ac2b6d5b35b1847e4
Nonce A:         7e968bba13b6c50e2c4cd7f241cc0d64d1ac25c7f5952df231ac6a2bda8ee5d6
Nonce B:         559aead08264d5795d3909718cdd05abd49572e84fe55590eef31a88a08fdffd
```

(Auth₁) RLPx v4 포맷 (A에서 B로 전송):
```text
048ca79ad18e4b0659fab4853fe5bc58eb83992980f4c9cc147d2aa31532efd29a3d3dc6a3d89eaf
913150cfc777ce0ce4af2758bf4810235f6e6ceccfee1acc6b22c005e9e3a49d6448610a58e98744
ba3ac0399e82692d67c1f58849050b3024e21a52c9d3b01d871ff5f210817912773e610443a9ef14
2e91cdba0bd77b5fdf0769b05671fc35f83d83e4d3b0b000c6b2a1b1bba89e0fc51bf4e460df3105
c444f14be226458940d6061c296350937ffd5e3acaceeaaefd3c6f74be8e23e0f45163cc7ebd7622
0f0128410fd05250273156d548a414444ae2f7dea4dfca2d43c057adb701a715bf59f6fb66b2d1d2
0f2c703f851cbf5ac47396d9ca65b6260bd141ac4d53e2de585a73d1750780db4c9ee4cd4d225173
a4592ee77e2bd94d0be3691f3b406f9bba9b591fc63facc016bfa8
```

(Auth₂) 버전 4, 추가 목록 요소 없는 EIP-8 포맷 (A에서 B로 전송):
```text
01b304ab7578555167be8154d5cc456f567d5ba302662433674222360f08d5f1534499d3678b513b
0fca474f3a514b18e75683032eb63fccb16c156dc6eb2c0b1593f0d84ac74f6e475f1b8d56116b84
9634a8c458705bf83a626ea0384d4d7341aae591fae42ce6bd5c850bfe0b999a694a49bbbaf3ef6c
da61110601d3b4c02ab6c30437257a6e0117792631a4b47c1d52fc0f8f89caadeb7d02770bf999cc
147d2df3b62e1ffb2c9d8c125a3984865356266bca11ce7d3a688663a51d82defaa8aad69da39ab6
d5470e81ec5f2a7a47fb865ff7cca21516f9299a07b1bc63ba56c7a1a892112841ca44b6e0034dee
70c9adabc15d76a54f443593fafdc3b27af8059703f88928e199cb122362a4b35f62386da7caad09
c001edaeb5f8a06d2b26fb6cb93c52a9fca51853b68193916982358fe1e5369e249875bb8d0d0ec3
6f917bc5e1eafd5896d46bd61ff23f1a863a8a8dcd54c7b109b771c8e61ec9c8908c733c0263440e
2aa067241aaa433f0bb053c7b31a838504b148f570c0ad62837129e547678c5190341e4f1693956c
3bf7678318e2d5b5340c9e488eefea198576344afbdf66db5f51204a6961a63ce072c8926c
```

(Auth₃) 버전 56, 3개의 추가 목록 요소가 있는 EIP-8 포맷 (A에서 B로 전송):
```text
01b8044c6c312173685d1edd268aa95e1d495474c6959bcdd10067ba4c9013df9e40ff45f5bfd6f7
2471f93a91b493f8e00abc4b80f682973de715d77ba3a005a242eb859f9a211d93a347fa64b597bf
280a6b88e26299cf263b01b8dfdb712278464fd1c25840b995e84d367d743f66c0e54a586725b7bb
f12acca27170ae3283c1073adda4b6d79f27656993aefccf16e0d0409fe07db2dc398a1b7e8ee93b
cd181485fd332f381d6a050fba4c7641a5112ac1b0b61168d20f01b479e19adf7fdbfa0905f63352
bfc7e23cf3357657455119d879c78d3cf8c8c06375f3f7d4861aa02a122467e069acaf513025ff19
6641f6d2810ce493f51bee9c966b15c5043505350392b57645385a18c78f14669cc4d960446c1757
1b7c5d725021babbcd786957f3d17089c084907bda22c2b2675b4378b114c601d858802a55345a15
116bc61da4193996187ed70d16730e9ae6b3bb8787ebcaea1871d850997ddc08b4f4ea668fbf3740
7ac044b55be0908ecb94d4ed172ece66fd31bfdadf2b97a8bc690163ee11f5b575a4b44e36e2bfb2
f0fce91676fd64c7773bac6a003f481fddd0bae0a1f31aa27504e2a533af4cef3b623f4791b2cca6
d490
```

(Ack₁) RLPx v4 포맷 (B에서 A로 전송):
```text
049f8abcfa9c0dc65b982e98af921bc0ba6e4243169348a236abe9df5f93aa69d99cadddaa387662
b0ff2c08e9006d5a11a278b1b3331e5aaabf0a32f01281b6f4ede0e09a2d5f585b26513cb794d963
5a57563921c04a9090b4f14ee42be1a5461049af4ea7a7f49bf4c97a352d39c8d02ee4acc416388c
1c66cec761d2bc1c72da6ba143477f049c9d2dde846c252c111b904f630ac98e51609b3b1f58168d
dca6505b7196532e5f85b259a20c45e1979491683fee108e9660edbf38f3add489ae73e3dda2c71b
d1497113d5c755e942d1
```

(Ack₂) 버전 4, 추가 목록 요소 없는 EIP-8 포맷 (B에서 A로 전송):
```text
01ea0451958701280a56482929d3b0757da8f7fbe5286784beead59d95089c217c9b917788989470
b0e330cc6e4fb383c0340ed85fab836ec9fb8a49672712aeabbdfd1e837c1ff4cace34311cd7f4de
05d59279e3524ab26ef753a0095637ac88f2b499b9914b5f64e143eae548a1066e14cd2f4bd7f814
c4652f11b254f8a2d0191e2f5546fae6055694aed14d906df79ad3b407d94692694e259191cde171
ad542fc588fa2b7333313d82a9f887332f1dfc36cea03f831cb9a23fea05b33deb999e85489e645f
6aab1872475d488d7bd6c7c120caf28dbfc5d6833888155ed69d34dbdc39c1f299be1057810f34fb
e754d021bfca14dc989753d61c413d261934e1a9c67ee060a25eefb54e81a4d14baff922180c395d
3f998d70f46f6b58306f969627ae364497e73fc27f6d17ae45a413d322cb8814276be6ddd13b885b
201b943213656cde498fa0e9ddc8e0b8f8a53824fbd82254f3e2c17e8eaea009c38b4aa0a3f306e8
797db43c25d68e86f262e564086f59a2fc60511c42abfb3057c247a8a8fe4fb3ccbadde17514b7ac
8000cdb6a912778426260c47f38919a91f25f4b5ffb455d6aaaf150f7e5529c100ce62d6d92826a7
1778d809bdf60232ae21ce8a437eca8223f45ac37f6487452ce626f549b3b5fdee26afd2072e4bc7
5833c2464c805246155289f4
```

(Ack₃) 버전 57, 3개의 추가 목록 요소가 있는 EIP-8 포맷 (B에서 A로 전송):
```text
01f004076e58aae772bb101ab1a8e64e01ee96e64857ce82b1113817c6cdd52c09d26f7b90981cd7
ae835aeac72e1573b8a0225dd56d157a010846d888dac7464baf53f2ad4e3d584531fa203658fab0
3a06c9fd5e35737e417bc28c1cbf5e5dfc666de7090f69c3b29754725f84f75382891c561040ea1d
dc0d8f381ed1b9d0d4ad2a0ec021421d847820d6fa0ba66eaf58175f1b235e851c7e2124069fbc20
2888ddb3ac4d56bcbd1b9b7eab59e78f2e2d400905050f4a92dec1c4bdf797b3fc9b2f8e84a482f3
d800386186712dae00d5c386ec9387a5e9c9a1aca5a573ca91082c7d68421f388e79127a5177d4f8
590237364fd348c9611fa39f78dcdceee3f390f07991b7b47e1daa3ebcb6ccc9607811cb17ce51f1
c8c2c5098dbdd28fca547b3f58c01a424ac05f869f49c6a34672ea2cbbc558428aa1fe48bbfd6115
8b1b735a65d99f21e70dbc020bfdface9f724a0d1fb5895db971cc81aa7608baa0920abb0a565c9c
436e2fd13323428296c86385f2384e408a31e104670df0791d93e743a3a5194ee6b076fb6323ca59
3011b7348c16cf58f66b9633906ba54a2ee803187344b394f75dd2e663a57b956cb830dd7a908d4f
39a2336a61ef9fda549180d4ccde21514d117b6c6fd07a9102b5efe710a32af4eeacae2cb3b1dec0
35b9593b48b9d3ca4c13d245d5f04169b0b1
```

노드 B는 (Auth₂, Ack₂)에 대한 연결 시크릿을 다음과 같이 파생합니다:

```text
aes-secret = 80e8632c05fed6fc2a13b0f8d31a3cf645366239170ea067065aba8e28bac487
mac-secret = 2ea74ec5dae199227dff1af715362700e989d889d7a493cb0639691efb8e5f98
```

문자열 "foo"에 대해 B의 `ingress-mac` keccak 상태를 실행하면 다음 해시가 생성됩니다:

```text
ingress-mac("foo") = 0c7ec6340062cc46f5e9f1e3cf86f8c8c403c5a0964f5df0ebd34a75ddc86db5
```

### 저작권

저작권 및 관련 권리는 [CC0](../LICENSE.md)를 통해 포기되었습니다.
