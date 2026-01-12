---
eip: 1
title: EIP 목적 및 가이드라인
status: Living
type: Meta
author: Martin Becze <mb@ethereum.org>, Hudson Jameson <hudson@ethereum.org>, et al.
created: 2015-10-27
lang: ko
original: ../eip-1.md
---

## EIP란 무엇인가?

EIP는 Ethereum Improvement Proposal(이더리움 개선 제안)의 약자입니다. EIP는 이더리움 커뮤니티에 정보를 제공하거나, 이더리움 또는 그 프로세스나 환경에 대한 새로운 기능을 설명하는 설계 문서입니다. EIP는 해당 기능의 간결한 기술 사양과 기능에 대한 근거를 제공해야 합니다. EIP 작성자는 커뮤니티 내에서 합의를 구축하고 반대 의견을 문서화할 책임이 있습니다.

## EIP의 근거

우리는 EIP가 새로운 기능을 제안하고, 이슈에 대한 커뮤니티 기술 의견을 수집하며, 이더리움에 적용된 설계 결정을 문서화하는 주요 메커니즘이 되도록 의도합니다. EIP는 버전 관리되는 저장소에 텍스트 파일로 유지되므로, 그 수정 이력이 기능 제안의 역사적 기록이 됩니다.

이더리움 구현자들에게 EIP는 구현 진행 상황을 추적하는 편리한 방법입니다. 이상적으로 각 구현 유지관리자는 자신이 구현한 EIP 목록을 제공할 것입니다. 이를 통해 최종 사용자는 특정 구현이나 라이브러리의 현재 상태를 쉽게 알 수 있습니다.

## EIP 유형

EIP에는 세 가지 유형이 있습니다:

- **Standards Track EIP(표준 트랙 EIP)**는 대부분 또는 모든 이더리움 구현에 영향을 미치는 변경사항을 설명합니다. 예를 들어 네트워크 프로토콜 변경, 블록 또는 트랜잭션 유효성 규칙 변경, 제안된 애플리케이션 표준/규약, 또는 이더리움을 사용하는 애플리케이션의 상호운용성에 영향을 미치는 변경이나 추가 사항이 해당됩니다. Standards Track EIP는 설계 문서, 구현, 그리고 (필요한 경우) [공식 사양](https://github.com/ethereum/yellowpaper) 업데이트의 세 부분으로 구성됩니다. 또한 Standards Track EIP는 다음 카테고리로 나눌 수 있습니다:
  - **Core(코어)**: 합의 포크가 필요한 개선사항 (예: [EIP-5](./eip-5.md), [EIP-101](./eip-101.md)), 반드시 합의에 영향을 미치지는 않지만 ["core dev" 논의](https://github.com/ethereum/pm)와 관련될 수 있는 변경사항 (예: [EIP-90], [EIP-86](./eip-86.md)의 채굴자/노드 전략 변경 2, 3, 4).
  - **Networking(네트워킹)**: [devp2p](https://github.com/ethereum/devp2p/blob/readme-spec-links/rlpx.md) ([EIP-8](./eip-8.md)) 및 [Light Ethereum Subprotocol](https://ethereum.org/en/developers/docs/nodes-and-clients/#light-node) 관련 개선사항과 [whisper](https://github.com/ethereum/go-ethereum/issues/16013#issuecomment-364639309) 및 [swarm](https://github.com/ethereum/go-ethereum/pull/2959)의 네트워크 프로토콜 사양에 대한 제안된 개선사항 포함.
  - **Interface(인터페이스)**: 메서드 이름([EIP-6](./eip-6.md)) 및 [컨트랙트 ABI](https://docs.soliditylang.org/en/develop/abi-spec.html)와 같은 언어 수준 표준 관련 개선사항 포함.
  - **ERC**: 토큰 표준([ERC-20](./eip-20.md)), 이름 레지스트리([ERC-137](./eip-137.md)), URI 스킴, 라이브러리/패키지 형식, 지갑 형식을 포함한 컨트랙트 표준 등 애플리케이션 수준 표준 및 규약.

- **Meta EIP(메타 EIP)**는 이더리움을 둘러싼 프로세스를 설명하거나 프로세스에 대한 변경(또는 이벤트)을 제안합니다. Process EIP는 Standards Track EIP와 유사하지만 이더리움 프로토콜 자체가 아닌 다른 영역에 적용됩니다. 구현을 제안할 수 있지만 이더리움 코드베이스에 대한 것은 아닙니다. 종종 커뮤니티 합의가 필요합니다. Informational EIP와 달리 단순한 권고 이상이며 사용자가 일반적으로 무시할 수 없습니다. 예를 들어 절차, 가이드라인, 의사결정 프로세스 변경, 이더리움 개발에 사용되는 도구나 환경 변경 등이 포함됩니다. 모든 Meta EIP는 Process EIP로도 간주됩니다.

- **Informational EIP(정보 제공 EIP)**는 이더리움 설계 이슈를 설명하거나 이더리움 커뮤니티에 일반적인 가이드라인이나 정보를 제공하지만, 새로운 기능을 제안하지는 않습니다. Informational EIP는 반드시 이더리움 커뮤니티 합의나 권고를 나타내는 것은 아니므로, 사용자와 구현자는 Informational EIP를 무시하거나 그 조언을 따를 수 있습니다.

단일 EIP에는 단일 핵심 제안이나 새로운 아이디어가 포함되는 것이 좋습니다. EIP가 집중될수록 성공할 가능성이 높습니다. 하나의 클라이언트에 대한 변경은 EIP가 필요하지 않습니다. 여러 클라이언트에 영향을 미치거나 여러 앱이 사용할 표준을 정의하는 변경에는 EIP가 필요합니다.

EIP는 특정 최소 기준을 충족해야 합니다. 제안된 개선사항에 대한 명확하고 완전한 설명이어야 합니다. 개선사항은 순 개선을 나타내야 합니다. 해당되는 경우 제안된 구현은 견고해야 하며 프로토콜을 불필요하게 복잡하게 만들어서는 안 됩니다.

### Core EIP의 특별 요구사항

**Core** EIP가 EVM(Ethereum Virtual Machine)에 대한 언급이나 변경을 제안하는 경우, 명령어를 니모닉으로 참조하고 해당 니모닉의 옵코드를 최소 한 번 정의해야 합니다. 선호되는 방식은 다음과 같습니다:

```
REVERT (0xfe)
```

## EIP 워크플로우

### EIP 관리하기

프로세스에 참여하는 당사자는 챔피언 또는 *EIP 작성자*인 당신, [*EIP 편집자*](#eip-편집자), 그리고 [*Ethereum Core Developers*](https://github.com/ethereum/pm)입니다.

공식 EIP 작성을 시작하기 전에 아이디어를 검토해야 합니다. 이전 연구를 기반으로 거부될 것에 시간을 낭비하지 않도록 먼저 이더리움 커뮤니티에 아이디어가 독창적인지 확인하세요. 이를 위해 [Ethereum Magicians 포럼](https://ethereum-magicians.org/)에서 토론 스레드를 여는 것이 좋습니다.

아이디어가 검토되면 다음 책임은 (EIP를 통해) 리뷰어와 모든 관심 있는 당사자에게 아이디어를 제시하고, 편집자, 개발자 및 커뮤니티를 초대하여 앞서 언급한 채널에서 피드백을 제공하는 것입니다. EIP에 대한 관심이 구현에 필요한 작업과 얼마나 많은 당사자가 이를 준수해야 하는지와 비례하는지 평가해야 합니다. 예를 들어, Core EIP를 구현하는 데 필요한 작업은 ERC보다 훨씬 크며, EIP는 이더리움 클라이언트 팀으로부터 충분한 관심이 필요합니다. 부정적인 커뮤니티 피드백은 고려되며 EIP가 Draft 단계를 넘어가지 못하게 할 수 있습니다.

### Core EIPs

Core EIP의 경우, **Final**로 간주되려면 클라이언트 구현이 필요하므로(아래 "EIP 프로세스" 참조), 클라이언트용 구현을 제공하거나 클라이언트가 EIP를 구현하도록 설득해야 합니다.

클라이언트 구현자들이 EIP를 검토하게 하는 가장 좋은 방법은 AllCoreDevs 콜에서 발표하는 것입니다. [AllCoreDevs 안건 GitHub Issue](https://github.com/ethereum/pm/issues)에 EIP를 링크하는 댓글을 게시하여 요청할 수 있습니다.

AllCoreDevs 콜은 클라이언트 구현자들이 세 가지를 수행하는 방법으로 사용됩니다. 첫째, EIP의 기술적 장점을 논의합니다. 둘째, 다른 클라이언트들이 무엇을 구현할지 파악합니다. 셋째, 네트워크 업그레이드를 위한 EIP 구현을 조정합니다.

이러한 콜은 일반적으로 어떤 EIP가 구현되어야 하는지에 대한 "대략적인 합의"로 이어집니다. 이 "대략적인 합의"는 EIP가 네트워크 분할을 일으킬 만큼 논쟁적이지 않고 기술적으로 건전하다는 가정에 기반합니다.

:warning: EIP 프로세스와 AllCoreDevs 콜은 논쟁적인 비기술적 문제를 다루도록 설계되지 않았지만, 이를 해결할 다른 방법이 없기 때문에 종종 이에 얽히게 됩니다. 이로 인해 클라이언트 구현자들은 커뮤니티 정서를 파악해야 하는 부담을 지게 되며, 이는 EIP와 AllCoreDevs 콜의 기술 조정 기능을 방해합니다. EIP를 관리하고 있다면, [Ethereum Magicians 포럼](https://ethereum-magicians.org/)의 EIP 스레드에 가능한 많은 커뮤니티 토론이 포함되거나 링크되어 있고 다양한 이해관계자가 잘 대표되도록 하여 커뮤니티 합의 구축 프로세스를 더 쉽게 만들 수 있습니다.

*요약하면, 챔피언으로서의 역할은 아래 설명된 스타일과 형식을 사용하여 EIP를 작성하고, 적절한 포럼에서 토론을 관리하며, 아이디어에 대한 커뮤니티 합의를 구축하는 것입니다.*

### EIP 프로세스

다음은 모든 트랙의 모든 EIP에 대한 표준화 프로세스입니다:

![EIP 상태 다이어그램](../../assets/eip-1/EIP-process-update.jpg)

**Idea(아이디어)** - 초안 이전의 아이디어입니다. EIP 저장소에서 추적되지 않습니다.

**Draft(초안)** - 개발 중인 EIP의 첫 번째 공식 추적 단계입니다. EIP가 적절하게 형식화되면 EIP 편집자에 의해 EIP 저장소에 병합됩니다.

**Review(검토)** - EIP 작성자가 EIP를 피어 리뷰 준비 및 요청 상태로 표시합니다.

**Last Call(마지막 검토)** - `Final`로 이동하기 전 EIP의 최종 검토 기간입니다. 사양이 안정되고 작성자가 검토 종료일(`last-call-deadline`, 일반적으로 14일 후)이 포함된 PR을 열면 EIP는 `Last Call`에 진입합니다.

이 기간에 필요한 규범적 변경이 발생하면 EIP를 `Review`로 되돌립니다.

**Final(최종)** - 이 EIP는 최종 표준을 나타냅니다. Final EIP는 최종 상태에 존재하며 오류 수정과 비규범적 설명 추가를 위해서만 업데이트되어야 합니다.

Last Call에서 Final로 EIP를 이동하는 PR에는 상태 업데이트 외에 다른 변경사항이 포함되어서는 안 됩니다. 제안된 콘텐츠 또는 편집 변경은 이 상태 업데이트 PR과 별도이어야 하며 그 전에 커밋되어야 합니다.

**Stagnant(정체)** - 6개월 이상 비활성 상태인 `Draft`, `Review` 또는 `Last Call` 상태의 EIP는 `Stagnant`로 이동됩니다. 작성자나 EIP 편집자가 `Draft` 또는 이전 상태로 되돌려 이 상태에서 부활시킬 수 있습니다. 부활하지 않으면 제안은 이 상태에 영원히 남을 수 있습니다.

>*EIP 작성자는 EIP 상태의 알고리즘적 변경에 대해 알림을 받습니다*

**Withdrawn(철회)** - EIP 작성자가 제안된 EIP를 철회했습니다. 이 상태는 최종적이며 이 EIP 번호를 사용하여 더 이상 부활시킬 수 없습니다. 나중에 아이디어를 추진하면 새 제안으로 간주됩니다.

**Living(활성)** - 지속적으로 업데이트되도록 설계되어 최종 상태에 도달하지 않는 EIP의 특별 상태입니다. 가장 대표적으로 EIP-1이 포함됩니다.

## 성공적인 EIP에 포함되어야 할 내용

각 EIP에는 다음 부분이 있어야 합니다:

- Preamble(서문) - EIP에 대한 메타데이터를 포함하는 RFC 822 스타일 헤더. EIP 번호, 짧은 설명 제목(최대 44자), 설명(최대 140자), 작성자 세부 정보 포함. 카테고리에 관계없이 제목과 설명에 EIP 번호를 포함해서는 안 됩니다. 자세한 내용은 [아래](./eip-1.md#eip-헤더-서문)를 참조하세요.
- Abstract(요약) - 여러 문장(짧은 단락)의 기술적 요약입니다. 사양 섹션의 매우 간결하고 읽기 쉬운 버전이어야 합니다. 누군가 요약만 읽고도 이 사양이 무엇을 하는지 파악할 수 있어야 합니다.
- Motivation(동기) *(선택사항)* - 이더리움 프로토콜을 변경하려는 EIP에 동기 섹션은 매우 중요합니다. EIP가 해결하는 문제를 해결하기 위해 기존 프로토콜 사양이 왜 부적절한지 명확하게 설명해야 합니다. 동기가 명백한 경우 이 섹션을 생략할 수 있습니다.
- Specification(사양) - 기술 사양은 새로운 기능의 구문과 의미를 설명해야 합니다. 사양은 현재 이더리움 플랫폼(besu, erigon, ethereumjs, go-ethereum, nethermind 등)에 대해 경쟁적이고 상호운용 가능한 구현을 허용할 만큼 상세해야 합니다.
- Rationale(근거) - 근거는 설계를 유발한 이유와 특정 설계 결정이 내려진 이유를 설명하여 사양을 구체화합니다. 고려된 대안 설계와 관련 작업(예: 다른 언어에서 기능이 지원되는 방식)을 설명해야 합니다. 근거는 EIP 논의 중 제기된 중요한 이의나 우려 사항을 논의해야 합니다.
- Backwards Compatibility(하위 호환성) *(선택사항)* - 하위 호환성 문제를 도입하는 모든 EIP는 이러한 비호환성과 그 결과를 설명하는 섹션을 포함해야 합니다. EIP는 작성자가 이러한 비호환성을 어떻게 처리할 것인지 설명해야 합니다. 제안이 하위 호환성 문제를 도입하지 않으면 이 섹션을 생략할 수 있지만, 하위 비호환성이 존재하면 이 섹션을 반드시 포함해야 합니다.
- Test Cases(테스트 케이스) *(선택사항)* - 합의 변경에 영향을 미치는 EIP에 대한 구현 테스트 케이스는 필수입니다. 테스트는 EIP에 데이터(입력/예상 출력 쌍 등)로 인라인되거나 `../assets/eip-###/<filename>`에 포함되어야 합니다. 비Core 제안의 경우 이 섹션을 생략할 수 있습니다.
- Reference Implementation(참조 구현) *(선택사항)* - 사람들이 이 사양을 이해하거나 구현하는 데 도움이 되는 참조/예제 구현을 포함하는 선택적 섹션입니다. 모든 EIP에서 이 섹션을 생략할 수 있습니다.
- Security Considerations(보안 고려사항) - 모든 EIP는 제안된 변경과 관련된 보안 영향/고려사항을 논의하는 섹션을 포함해야 합니다. 보안 논의에 중요할 수 있는 정보를 포함하고, 위험을 표면화하며, 제안의 수명 주기 전반에 걸쳐 사용할 수 있습니다. 예: 보안 관련 설계 결정, 우려 사항, 중요한 논의, 구현별 지침 및 함정, 위협 및 위험 개요와 해결 방법. "Security Considerations" 섹션이 없는 EIP 제출은 거부됩니다. EIP는 리뷰어가 충분하다고 판단하는 Security Considerations 논의 없이는 "Final" 상태로 진행할 수 없습니다.
- Copyright Waiver(저작권 포기) - 모든 EIP는 퍼블릭 도메인에 있어야 합니다. 저작권 포기는 라이선스 파일에 링크하고 다음 문구를 사용해야 합니다: `Copyright and related rights waived via [CC0](../LICENSE.md).`

## EIP 형식 및 템플릿

EIP는 [마크다운](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) 형식으로 작성되어야 합니다. 따라야 할 [템플릿](https://github.com/ethereum/EIPs/blob/master/eip-template.md)이 있습니다.

## EIP 헤더 서문

각 EIP는 세 개의 하이픈(`---`)으로 앞뒤가 구분된 [RFC 822](https://www.ietf.org/rfc/rfc822.txt) 스타일 헤더 서문으로 시작해야 합니다. 이 헤더는 [Jekyll에서 "front matter"](https://jekyllrb.com/docs/front-matter/)라고도 합니다. 헤더는 다음 순서로 나타나야 합니다.

`eip`: *EIP 번호*

`title`: *EIP 제목은 몇 단어로, 완전한 문장이 아님*

`description`: *설명은 하나의 완전한 (짧은) 문장*

`author`: *작성자의 이름 및/또는 사용자명, 또는 이름과 이메일 목록. 자세한 내용은 아래 참조.*

`discussions-to`: *공식 토론 스레드를 가리키는 URL*

`status`: *Draft, Review, Last Call, Final, Stagnant, Withdrawn, Living*

`last-call-deadline`: *마지막 검토 기간이 종료되는 날짜* (선택적 필드, `Last Call` 상태일 때만 필요)

`type`: *`Standards Track`, `Meta`, 또는 `Informational` 중 하나*

`category`: *`Core`, `Networking`, `Interface`, 또는 `ERC` 중 하나* (선택적 필드, `Standards Track` EIP에만 필요)

`created`: *EIP가 생성된 날짜*

`requires`: *EIP 번호* (선택적 필드)

`withdrawal-reason`: *EIP가 철회된 이유를 설명하는 문장.* (선택적 필드, `Withdrawn` 상태일 때만 필요)

목록을 허용하는 헤더는 요소를 쉼표로 구분해야 합니다.

날짜가 필요한 헤더는 항상 ISO 8601 형식(yyyy-mm-dd)을 사용합니다.

### `author` 헤더

`author` 헤더는 EIP의 작성자/소유자의 이름, 이메일 주소 또는 사용자명을 나열합니다. 익명을 선호하는 사람은 사용자명만 또는 이름과 사용자명을 사용할 수 있습니다. `author` 헤더 값의 형식은 다음과 같아야 합니다:

> Random J. User &lt;address@dom.ain&gt;

또는

> Random J. User (@username)

또는

> Random J. User (@username) &lt;address@dom.ain&gt;

이메일 주소 및/또는 GitHub 사용자명이 포함된 경우, 그리고

> Random J. User

이메일 주소나 GitHub 사용자명이 제공되지 않은 경우.

변경 요청에 대한 알림을 받고 승인 또는 거부할 수 있도록 최소 한 명의 작성자가 GitHub 사용자명을 사용해야 합니다.

### `discussions-to` 헤더

EIP가 초안인 동안 `discussions-to` 헤더는 EIP가 논의되는 URL을 나타냅니다.

선호되는 토론 URL은 [Ethereum Magicians](https://ethereum-magicians.org/)의 토픽입니다. URL은 GitHub pull request, 일시적인 URL, 시간이 지나면 잠길 수 있는 URL(예: Reddit 토픽)을 가리킬 수 없습니다.

### `type` 헤더

`type` 헤더는 EIP의 유형을 지정합니다: Standards Track, Meta, 또는 Informational. 트랙이 Standards인 경우 하위 카테고리(core, networking, interface, 또는 ERC)를 포함하세요.

### `category` 헤더

`category` 헤더는 EIP의 카테고리를 지정합니다. 이것은 standards-track EIP에만 필요합니다.

### `created` 헤더

`created` 헤더는 EIP에 번호가 할당된 날짜를 기록합니다. 두 헤더 모두 yyyy-mm-dd 형식이어야 합니다(예: 2001-08-14).

### `requires` 헤더

EIP에는 이 EIP가 의존하는 EIP 번호를 나타내는 `requires` 헤더가 있을 수 있습니다. 그러한 의존성이 존재하면 이 필드가 필요합니다.

`requires` 의존성은 현재 EIP가 다른 EIP의 개념이나 기술 요소 없이는 이해되거나 구현될 수 없을 때 생성됩니다. 단순히 다른 EIP를 언급하는 것이 반드시 그러한 의존성을 생성하는 것은 아닙니다.

## 외부 리소스 링크

아래 나열된 특정 예외를 제외하고 외부 리소스에 대한 링크는 **포함해서는 안 됩니다**. 외부 리소스는 예기치 않게 사라지거나 이동하거나 변경될 수 있습니다.

허용된 외부 리소스를 관리하는 프로세스는 [EIP-5757](./eip-5757.md)에 설명되어 있습니다.

### 실행 클라이언트 사양

이더리움 실행 클라이언트 사양에 대한 링크는 일반 마크다운 구문을 사용하여 포함할 수 있습니다.

### 합의 계층 사양

이더리움 합의 계층 사양 내 파일의 특정 커밋에 대한 링크는 일반 마크다운 구문을 사용하여 포함할 수 있습니다.

### 네트워킹 사양

이더리움 네트워킹 사양 내 파일의 특정 커밋에 대한 링크는 일반 마크다운 구문을 사용하여 포함할 수 있습니다.

### 기타 허용된 외부 리소스

- W3C(World Wide Web Consortium) 권고 사양
- WHATWG(Web Hypertext Application Technology Working Group) 사양
- IETF(Internet Engineering Task Force) RFC
- Bitcoin Improvement Proposals
- NVD(National Vulnerability Database) CVE
- CAIPs(Chain Agnostic Improvement Proposals)
- Ethereum Yellow Paper
- 실행 클라이언트 사양 테스트
- DOI(Digital Object Identifier) 시스템
- 실행 API 사양

## 다른 EIP에 링크하기

다른 EIP에 대한 참조는 참조하는 EIP 번호인 `EIP-N` 형식을 따라야 합니다. EIP에서 참조되는 각 EIP는 처음 참조될 때 상대 마크다운 링크가 **반드시** 동반되어야 하며, 이후 참조에서는 링크가 동반될 **수도** 있습니다. 링크는 **반드시** 상대 경로를 통해 이루어져야 이 GitHub 저장소, 이 저장소의 포크, 메인 EIP 사이트, 메인 EIP 사이트의 미러 등에서 링크가 작동합니다. 예를 들어, 이 EIP에 `./eip-1.md`로 링크합니다.

## 보조 파일

이미지, 다이어그램 및 보조 파일은 해당 EIP의 `assets` 폴더 하위 디렉토리에 다음과 같이 포함되어야 합니다: `assets/eip-N` (여기서 **N**은 EIP 번호로 대체됨). EIP에서 이미지에 링크할 때는 `../assets/eip-1/image.png`와 같은 상대 링크를 사용합니다.

## EIP 소유권 이전

때때로 EIP의 소유권을 새 챔피언에게 이전해야 할 필요가 있습니다. 일반적으로 원래 작성자를 이전된 EIP의 공동 작성자로 유지하고 싶지만, 이는 실제로 원래 작성자에게 달려 있습니다. 소유권을 이전하는 좋은 이유는 원래 작성자가 더 이상 업데이트하거나 EIP 프로세스를 진행할 시간이나 관심이 없거나, 인터넷에서 사라졌기 때문입니다(즉, 연락이 안 되거나 이메일에 응답하지 않음). 소유권을 이전하는 나쁜 이유는 EIP의 방향에 동의하지 않기 때문입니다. 우리는 EIP 주변에 합의를 구축하려고 노력하지만, 그것이 불가능하면 항상 경쟁 EIP를 제출할 수 있습니다.

EIP의 소유권을 인수하는 데 관심이 있다면 원래 작성자와 EIP 편집자 모두에게 인수 요청 메시지를 보내세요. 원래 작성자가 적시에 이메일에 응답하지 않으면 EIP 편집자가 일방적으로 결정을 내릴 것입니다(그러한 결정을 번복할 수 없는 것은 아닙니다 :)).

## EIP 편집자

현재 EIP 편집자는 다음과 같습니다:

- Matt Garnett (@lightclient)
- Sam Wilson (@SamWilsn)
- Zainan Victor Zhou (@xinbenlv)
- Gajinder Singh (@g11tech)
- Jochem Brouwer (@jochem-brouwer)

명예 EIP 편집자는 다음과 같습니다:

- Alex Beregszaszi (@axic)
- Casey Detrio (@cdetrio)
- Gavin John (@Pandapip1)
- Greg Colvin (@gcolvin)
- Hudson Jameson (@Souptacular)
- Martin Becze (@wanderer)
- Micah Zoltu (@MicahZoltu)
- Nick Johnson (@arachnid)
- Nick Savers (@nicksavers)
- Vitalik Buterin (@vbuterin)

EIP 편집자가 되고 싶다면 [EIP-5069](./eip-5069.md)를 확인하세요.

## EIP 편집자 책임

새로운 EIP가 들어올 때마다 편집자는 다음을 수행합니다:

- EIP가 준비되었는지 확인하기 위해 읽기: 건전하고 완전한지. 아이디어가 최종 상태에 도달할 것 같지 않더라도 기술적으로 타당해야 합니다.
- 제목이 내용을 정확하게 설명해야 합니다.
- 언어(철자, 문법, 문장 구조 등), 마크업(GitHub flavored Markdown), 코드 스타일 확인

EIP가 준비되지 않았으면 편집자는 구체적인 지침과 함께 수정을 위해 작성자에게 돌려보냅니다.

EIP가 저장소에 준비되면 EIP 편집자는:

- EIP 번호 할당(일반적으로 증분; 번호 스나이핑이 의심되면 편집자가 재할당할 수 있음)
- 해당 [pull request](https://github.com/ethereum/EIPs/pulls) 병합
- 다음 단계와 함께 EIP 작성자에게 메시지 전송

많은 EIP는 이더리움 코드베이스에 쓰기 액세스 권한이 있는 개발자에 의해 작성되고 유지됩니다. EIP 편집자는 EIP 변경사항을 모니터링하고 보이는 구조, 문법, 철자 또는 마크업 실수를 수정합니다.

편집자는 EIP에 대해 판단을 내리지 않습니다. 우리는 단지 행정 및 편집 업무를 수행합니다.

## 스타일 가이드

### 제목

서문의 `title` 필드는:

- "standard"라는 단어 또는 그 변형을 포함해서는 안 됩니다.
- EIP 번호를 포함해서는 안 됩니다.

### 설명

서문의 `description` 필드는:

- "standard"라는 단어 또는 그 변형을 포함해서는 안 됩니다.
- EIP 번호를 포함해서는 안 됩니다.

### EIP 번호

`category`가 `ERC`인 EIP를 참조할 때는 `ERC-X` 형식의 하이픈 표기법으로 작성해야 합니다(여기서 `X`는 해당 EIP의 할당된 번호). 다른 `category`의 EIP를 참조할 때는 `EIP-X` 형식의 하이픈 표기법으로 작성해야 합니다(여기서 `X`는 해당 EIP의 할당된 번호).

### RFC 2119 및 RFC 8174

EIP는 용어에 대해 [RFC 2119](https://www.ietf.org/rfc/rfc2119.html) 및 [RFC 8174](https://www.ietf.org/rfc/rfc8174.html)를 따르고 사양 섹션 시작 부분에 다음을 삽입하는 것이 좋습니다:

> 이 문서의 핵심 단어 "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", "OPTIONAL"은 RFC 2119 및 RFC 8174에 설명된 대로 해석됩니다.

## 역사

이 문서는 Amir Taaki가 작성한 [Bitcoin의 BIP-0001](https://github.com/bitcoin/bips)에서 많은 부분을 가져왔으며, 이는 다시 [Python의 PEP-0001](https://peps.python.org/)에서 파생되었습니다. 많은 곳에서 텍스트가 단순히 복사되어 수정되었습니다. PEP-0001 텍스트는 Barry Warsaw, Jeremy Hylton, David Goodger가 작성했지만, 이더리움 개선 프로세스에서의 사용에 대한 책임이 없으며 이더리움 또는 EIP에 특정한 기술적 질문으로 귀찮게 해서는 안 됩니다. 모든 댓글은 EIP 편집자에게 직접 보내주세요.

## 저작권

저작권 및 관련 권리는 [CC0](../LICENSE.md)를 통해 포기됩니다.
