rem ============================================================
rem [윈도우 실습실 사이트 차단 스크립트]
rem
rem   본 스크립트는 포스텍 수리데이터과학연구소 청소년수리인공지능아카데미
rem   프로그래밍 실습 중 학생들의 집중을 돕기 위해 제작되었습니다.
rem   
rem   특정 플래쉬 게임 사이트 등의 도메인을 로컬로 리다이렉트하여 차단합니다.
rem
rem   1. 이 파일을 실습용 컴퓨터 다운로드 폴더에 저장합니다.
rem   2. CMD를 '관리자 권한으로 실행' 합니다.
rem   3. CMD에서 C:\Users\USER\Downloads\please_focus.bat 실행 합니다.
rem ============================================================

@echo off
rem @echo off : 실행되는 명령어 줄 자체는 숨기고, 결과만 화면에 보여줍니다.

setlocal enabledelayedexpansion
rem setlocal enabledelayedexpansion : 루프 내 변수 지연 확장 사용

rem ============================================================
rem ★ 차단할 사이트 목록 (세미콜론 ; 으로 구분, 띄어쓰기 금지)
rem ============================================================
set "TARGETS=vidkidz.tistory.com;vidkidz.github.io;flasharch.com"

rem 시스템 hosts 파일 경로
set "HOSTS_FILE=C:\Windows\System32\drivers\etc\hosts"

rem 섹션 구분용 헤더
set "HEADER_LINE1=# POSTECH Youth Mathematical Artificial Intelligence Academy"
set "HEADER_LINE2=#   - helps students stay focused during programming sessions"

echo.
echo [!] Starting website blocking process...
echo.

rem ------------------------------------------------------------
rem 1. 헤더(주석 섹션) 확인
rem ------------------------------------------------------------
rem 파일 전체에서 헤더 텍스트를 검색
findstr /C:"%HEADER_LINE1%" "%HOSTS_FILE%" >nul
if errorlevel 1 (
    rem 헤더가 없으면 파일 맨 끝에 새로 추가
    echo. >> "%HOSTS_FILE%"
    echo. >> "%HOSTS_FILE%"
    echo %HEADER_LINE1% >> "%HOSTS_FILE%"
    echo %HEADER_LINE2% >> "%HOSTS_FILE%"
    echo [SETUP] Created new block list section. Updating list...
) else (
    rem 헤더가 이미 있으면 헤더 추가 과정 생략
    echo [SETUP] Updating list...
)

rem ------------------------------------------------------------
rem 2. 사이트 목록 순회 및 차단 규칙 추가
rem ------------------------------------------------------------
rem 세미콜론을 공백으로 치환하여 리스트화
set "LIST=%TARGETS:;= %"

for %%D in (%LIST%) do (
    rem 파일 전체를 검색하여 해당 도메인이 이미 차단되었는지 확인
    findstr /C:"127.0.0.1       %%D" "%HOSTS_FILE%" >nul
    if errorlevel 1 (
        rem 차단 규칙이 없으면 파일 맨 끝에 추가
        echo 127.0.0.1       %%D >> "%HOSTS_FILE%"
        
        rem 차단된 사이트를 개별적으로 출력
        echo [BLOCKED] %%D
    ) else (
        rem 이미 존재하면 건너뜀
        echo [SKIPPED] %%D is already blocked.
    )
)

rem ------------------------------------------------------------
rem 3. DNS 캐시 초기화 (즉시 적용)
rem ------------------------------------------------------------
ipconfig /flushdns
echo.
echo [!] The website blocking process is complete.
echo.
pause