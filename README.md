# FPGA

- Verilog 기반 디지털 논리회로 및 FPGA 실습 기록
- 기본 논리 게이트부터 버튼 디바운싱, 카운터까지 단계별 구성
- 회로 설계 소스, 테스트벤치, Vivado 프로젝트 파일 포함

## 개발 환경

- 언어: Verilog HDL
- 개발 도구: Xilinx Vivado 2020.2
- 대상 보드: Digilent Basys 3 (Artix-7)
- 시뮬레이션: Vivado Simulator (XSim)

## 실습 구성

- `01.gate_test`: 기본 논리 게이트
- `02.adder`: 반가산기, 전가산기, 4비트 가산기
- `02.half_adder`: 반가산기 프로젝트 파일
- `03.adder4`: 4비트·8비트 가산기
- `04.mux_decoder_encoder_compare`: 2:1 멀티플렉서 실습
- `05.mux_4bit`: 4비트 멀티플렉서
- `06.priority_encoder`: 우선순위 인코더
- `07.adder_subtractor`: 가산·감산 회로
- `08.rom`: ROM 설계 및 시뮬레이션
- `09.comparator`: 4비트 비교기
- `10.btn_debounce`: 버튼 디바운싱 및 LED 제어
- `my_up_counter`: 버튼으로 실행·정지 및 정지 중 초기화가 가능한 LED 카운터

## 실행 방법

- Vivado에서 실습 폴더의 `.xpr` 파일 열기
- 설계 소스와 최상위 모듈 확인
- 테스트벤치가 있는 실습은 `Run Behavioral Simulation`으로 파형 확인
- 보드 동작 확인 시 XDC 핀 설정 확인 후 합성 → 구현 → 비트스트림 생성 → 보드 다운로드

## 참고 자료

- `my_btn_debounce 회로도.pdf`: 버튼 디바운싱 회로도
- `my_up_counter 회로도.pdf`: 카운터 회로도
