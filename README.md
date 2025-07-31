# 📅 Calin(일정관리 앱)

## Architecture

- Mvvm-C 패턴과 Repository 기반의 클린아키텍처 적용
- SwiftData를 이용한 CRUD 기능 적용
- 코디네이터를 통한 화면전환 기능 적용

# Structure 
	- Presentation Layer (View + ViewModel)
	  - 화면(UI)과 사용자 상호작용을 처리합니다.
	  - ViewModel은 상태와 로직을 관리하며, UseCase를 통해 도메인 계층과 통신합니다.
	  - Coordinator는 화면 간의 전환 로직을 담당합니다.
	- Domain Layer
	  - 앱의 비즈니스 로직을 담당합니다.
	  - UseCase를 통해 Presentation ↔ Data 계층의 중간 다리 역할을 수행합니다.
	  - 도메인 모델은 UI와 무관하게 순수한 형태로 유지됩니다.
	- Data Layer
	  - 실제 데이터 저장 및 조회를 담당합니다.
	  - Repository 인터페이스를 도메인 계층에 제공하며, 내부적으로는 SwiftData 등의 로컬 저장소를 사용합니다.
	  - DTO → Domain Model 매핑을 통해 도메인 계층과의 의존성을 분리합니다.
