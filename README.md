# Github 유저 검색 서비스

>  GitHub 유저를 검색하고 즐겨찾기할 수 있는 앱

![Swift](https://img.shields.io/badge/Swift-5.5-orange.svg) ![iOS](https://img.shields.io/badge/Platform-iOS-lightgrey.svg)

| API 검색 화면                                                | 로컬 즐겨찾기 화면                                           |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![github-search-api](https://user-images.githubusercontent.com/56751259/139578633-2f8a3e09-2ed9-4d3c-88f6-050f8496eb51.png) | ![github-search-local](https://user-images.githubusercontent.com/56751259/139578659-ec4b7a99-2b5e-42d7-8bc7-31203f36a07b.png) |

## 기본 동작

### 모든 유저 검색

![github-search-api](https://user-images.githubusercontent.com/56751259/139575871-962cbdfd-d521-4cdf-b9b2-d454188cfb5c.gif)

* **All** 탭이 선택된 상태에서 유저 이름을 입력합니다. 검색어를 입력하고 **Search** 버튼을 누르면 검색 결과가 목록 형태로 나타납니다.
* 각 목록은 아바타 이미지, 유저 이름, 즐겨찾기 여부로 구성되어 있습니다.

![github-search-api-scrolling](https://user-images.githubusercontent.com/56751259/139576377-739cb6dc-d683-474b-9b5d-e65d73032425.gif)

* 한번에 모든 검색 결과를 보여주는 대신 30건씩 끊어 스크롤을 할때마다 추가 로드합니다.

![github-search-api-rate-limit](https://user-images.githubusercontent.com/56751259/139576840-914b28ef-d5cd-471f-adeb-dcbbecea0124.gif)

* 사용한 API는 1분당 10건으로 요청 횟수가 제한되어 있습니다. 요청 횟수를 초과하게 되면 에러창이 뜹니다.

### 즐겨찾기 추가/삭제

![github-search-star](https://user-images.githubusercontent.com/56751259/139577210-22b7e5f4-2863-4ffb-a72b-a3c5ce011252.gif)

* 즐겨찾기에 추가된 유저는 꽉찬 별(★)로 표시됩니다. 반면에 즐겨찾기에 추가되지 않은 유저는 빈별(☆)로 표시됩니다.
* 즐겨찾기에 추가되지 않은 유저의 빈별(☆)을 탭하면 꽉찬 별(★)로 변경됩니다. **Starred** 탭으로 이동하면 방금 즐겨찾기한 유저를 확인할 수 있습니다.

![github-search-unstar](https://user-images.githubusercontent.com/56751259/139577811-6d82eb13-8f5a-453f-8e87-7eec5a30ab12.gif)

* 즐겨찾기에 추가된 유저의 꽉찬 별(★)을 탭하면 빈별(☆)로 변경됩니다. **All** 탭으로 이동하면 방금 즐겨찾기를 삭제한 유저가 빈별(☆)로 표시됨을 확인할 수 있습니다. 다시 **Starred** 탭으로 이동하면 해당 유저는 즐겨찾기에서 삭제되어 보이지 않습니다.

### 즐겨찾기 유저 검색

![github-search-local](https://user-images.githubusercontent.com/56751259/139578011-1f87efb9-fb23-4aca-8656-ec667b5b6774.gif)

* **Starred** 탭에서는 즐겨찾기한 유저를 확인할 수 있습니다. (즐겨찾기한 유저는 로컬에 저장되어 있습니다.)
* 즐겨찾기 유저 목록은 이름의 첫글자를 기준으로 같은 헤더로 묶여 있습니다. 이 헤더는 오름차순으로 정렬되어 있습니다.

![github-search-local-searching](https://user-images.githubusercontent.com/56751259/139578449-37bc08ec-fa39-4d10-a30c-2e89fb461b10.gif)

* **Starred** 탭이 선택된 상태에서 유저 이름을 입력합니다. 검색어를 입력하고 **Search** 버튼을 누르면 전체 즐겨찾기 유저 목록 중 검색어를 포함한 결과만 필터되어 보여집니다.

## 상세 구현 내용

### Architecture - MVVM & Clean Architecture

MVVM과 Clean Architecture를 적용해 프로젝트를 진행했습니다. 처음에는 기본적으로 뷰가 하나밖에 없는만큼 간단한 구조에 적합한 MVC로 진행하는 것도 고려했습니다. 하지만 뜯어보면 모든 유저뷰와 즐겨찾기한 유저뷰 양쪽에서 각각 검색을 가능해야한 구조이므로 MVC 코드로 구현하기에는 생각만큼 간단하지 않은 구조가 될 것이라 판단했습니다. 이에 코드 구현양은 많아질 수 있지만 MVVM 구조로 진행하는 것이 적절하게 코드를 분리해 가독성 있는 코드로 작성하고자 했습니다. 또한 프로젝트 기간 동안은 작성하지 못했지만 View Model에 대한 테스트를 진행할 계획이 있으므로 더더욱 MVVM으로 진행하는 것이 좋겠다고 생각했습니다.

* Layers
  * Domain Layer
    * Entities: 유저 정보를 보여주는 데 사용하는 `User` 엔티티와 페이지별 유저 목록을 보여주는 데 사용하는 `UsersPage` 엔티티를 구조체로 생성했습니다.
    * Use Cases: 내부에 `UsersRepository`를 가지고 외부에서 매개 변수로 `query`와 `page`를 전달 받아 유저 검색을 실행할 수 있도록 클래스를 생성했습니다.
  * Data Layer
    * Repositories: 내부에 `DataTransferService` 객체를 가지고 유저 페이지, 아바타 이미지를 가져올 수 있는 레포지토리 클래스를 각각 생성했습니다. 각 클래스가 프로토콜을 채택하도록 해 한번 더 추상화를 해주었습니다.
    * API (Network): `NetworkService` 객체를 통해 네트워크 통신을, `DataTransferService` 객체를 통해 디코딩을 처리해주었씁니다.
      * 사용한 API는 요청에 대한 응답의 reponse의 헤더에 다음 페이지 URL을 담아 보내줍니다. 그렇기에 일반적으로 리퀘스트 성공, 실패에 따라 Data, Error만 처리하는 것과 달리 Response 역시 Completion Handler를 통해 함께 전달해주었습니다. `NetworkService`가 전달한 Response는 `DataTransferService`에서 파싱해 다음 페이지 URL만 뽑아냈습니다.
      * 또한 Rate Limit을 초과한 경우 API는 Response의 Status code를 403으로 보내줍니다. 에러 처리를 통해 이 경우 Alert 창을 띄워 유저에게 상황을 전달할 수 있도록 구현했습니다.
    * Persistence DB: 즐겨찾기한 유저를 로컬 저장하기 위해 Core Data를 활용했습니다. AppDelegate에 기본으로 구현되어 있던 Core Data 관련 코드를 별도의 클래스로 옮기고 클래스를 싱글톤으로 만들어주었습니다.
  * Presentation Layer (MVVM)
    * Views & View Models
      * 스토리보드를 제거하고 코드로 뷰를 구현했습니다. 테이블뷰의 셀은 Xib로 만들었습니다.
      * 뷰컨트롤러에서는 바인딩을 통해 뷰가 뷰모델의 상태 변화를 옵저빙할 수 있게 해주었습니다. 바인딩에는 RxSwift를 이용했습니다. 이를 통해 뷰모델의 속성값이 변경되면 자동으로 뷰를 업데이트 합니다.

### RxSwift 활용

이번 프로젝트를 진행하며 RxSwift를 학습하고 프로젝트에 적용해보았습니다. 확실히 러닝커브가 높다고 느껴지긴 했지만 View Model을 바인딩해주는 작업에 있어 RxSwift를 사용하지 않고 Completion Handler로 넘기거나 별도의 Observable을 직접 구현하는 것에 비해 심플해진다는 느낌이 들었습니다.

앱의 중심이 되는 테이블뷰는 기본 Data Source를 활용하지 않고 RxCocoa와 RxDataSouces만으로 구현했습니다. 모든 유저와 즐겨찾기한 유저를 한 테이블뷰로 보여주는 구조이므로 선택된 Segmented Control의 인덱스에 따라 사용하는 라이브러리를 달리해 테이블뷰의 내용을 채워주었습니다.

처음 RxSwift를 활용해 작성한 코드라 어색한 부분이 많을 수 있는데 차차 리팩토링을 통해 개선시켜 나가고 싶습니다.

### Core Data 활용

즐겨찾기한 유저를 로컬에 저장하기 위해 Core Data 프레임워크를 활용했습니다. CRUD 중 즐겨찾기에 저장, 즐겨찾기에서 제거, 즐겨찾기 목록 조회의 세 가지를 구현했습니다. 섹션 헤더뷰의 구현을 이해 즐겨찾기 목록을 Core Data Entity 타입의 배열 대신 첫글자와 View Model 배열의 딕셔너리 형태로 만들었기 때문에 매핑을 통해 Core Data Entity와 Domain Entity간의 전환을 자유롭게 만들어주었습니다.

## 개발 환경 설정

* iOS Deployment Target: 11.0
* Xcode Version: 13.1
* API: https://api.github.com/search/users
  * 관련 문서: https://docs.github.com/en/rest/reference/search

## 키워드

MVVM, Dependency Injection, Clean Architecture, RxSwift, Core Data

## 로드맵

- [ ] RxSwift 코드 리팩토링
- [ ] View Model 유닛테스트
- [ ] Activity Indicator 추가
- [ ] 화면 전환을 보다 부드럽게 만들기

## References

* [kudoleh / iOS-Clean-Architecture-MVVM](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM)
* [ReactiveX / RxSwift](https://github.com/ReactiveX/RxSwift)
