# Hugging Face 모델 지원 테스트 가이드

이 가이드는 ollama.com 접속이 제한된 환경에서 Term-Code를 사용하기 위한 새로운 기능을 테스트하는 방법을 설명합니다.

## 테스트 환경 요구사항
- Ubuntu Linux (또는 WSL)
- Node.js 18+ 
- Git
- 인터넷 연결 (GitHub, Hugging Face 접속 가능)
- ollama.com은 접속 불가여도 됨

## 테스트 절차

### 1. 저장소 클론 및 브랜치 체크아웃
```bash
# 저장소 클론
git clone https://github.com/huiseo/term-code.git
cd term-code

# 테스트 브랜치로 체크아웃
git checkout feat/huggingface-model-support

# claude-code 디렉토리로 이동
cd claude-code
```

### 2. Ollama 설치 (ollama.com 접속 없이)
```bash
# 스크립트 실행 권한 부여
chmod +x install-ollama-huggingface.sh

# Ollama 설치 (GitHub에서 다운로드)
./install-ollama-huggingface.sh
```

예상 결과:
- Ollama 바이너리가 GitHub에서 다운로드됨
- `/usr/local/bin/ollama`에 설치됨
- systemd 서비스 생성 및 시작

### 3. Ollama 서비스 확인
```bash
# 서비스 상태 확인
systemctl status ollama

# API 응답 확인
curl http://localhost:11434/api/tags
```

### 4. Hugging Face에서 모델 가져오기
```bash
# 스크립트 실행 권한 부여
chmod +x huggingface-model-import.sh

# 작은 테스트 모델 다운로드 (TinyLlama 1.1B, 약 668MB)
./huggingface-model-import.sh TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf tinyllama:test
```

예상 소요 시간: 2-5분 (네트워크 속도에 따라)

### 5. 모델 테스트
```bash
# 설치된 모델 목록 확인
ollama list

# 모델 실행 테스트
echo "Python에서 Hello World 출력하는 방법은?" | ollama run tinyllama:test

# 또는 대화형으로 테스트
ollama run tinyllama:test
```

### 6. Term-Code 설치 및 테스트
```bash
# Term-Code 설치
./install-linux.sh

# 또는 npm으로 직접 설치
npm install -g .

# Term-Code로 모델 사용
tcode ollama:list
tcode ollama:use tinyllama:test
tcode ask "JavaScript에서 배열을 역순으로 정렬하는 방법은?"
```

## 테스트 체크리스트

- [ ] Ollama가 ollama.com 접속 없이 설치되는가?
- [ ] Ollama 서비스가 정상적으로 시작되는가?
- [ ] Hugging Face에서 모델을 다운로드할 수 있는가?
- [ ] 다운로드한 모델이 Ollama에 정상적으로 등록되는가?
- [ ] 모델이 정상적으로 실행되고 응답하는가?
- [ ] Term-Code에서 모델을 사용할 수 있는가?

## 추가 테스트 (선택사항)

### 다른 모델 테스트
```bash
# 코딩 특화 모델 (1.3GB)
./huggingface-model-import.sh TheBloke/deepseek-coder-1.3b-instruct-GGUF deepseek-coder-1.3b-instruct.Q4_K_M.gguf deepseek-coder:1.3b

# 더 큰 모델 (4GB+, 시간이 오래 걸림)
./huggingface-model-import.sh TheBloke/Mistral-7B-v0.1-GGUF mistral-7b-v0.1.Q4_K_M.gguf mistral:7b
```

## 문제 발생 시

### 1. 스크립트 실행 오류
```bash
# 줄바꿈 문제 해결
dos2unix install-ollama-huggingface.sh
dos2unix huggingface-model-import.sh
```

### 2. Ollama 서비스가 시작되지 않을 때
```bash
# 수동으로 실행
ollama serve

# 로그 확인
journalctl -u ollama -f
```

### 3. 모델 다운로드가 실패할 때
- 네트워크 연결 확인
- Hugging Face 접속 가능 여부 확인
- 디스크 공간 확인 (최소 2GB 여유 공간 필요)

## 피드백 제공

테스트 후 다음 정보를 포함하여 피드백을 제공해주세요:

1. 테스트 환경 (OS, 버전)
2. 각 단계별 성공/실패 여부
3. 발생한 오류 메시지
4. 개선 제안사항

Issue 생성: https://github.com/huiseo/term-code/issues/new