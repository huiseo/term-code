# 빠른 설치 가이드 (ollama.com 접속 불가 환경)

이 가이드는 ollama.com에 접속할 수 없는 환경에서 Term-Code를 사용하는 방법입니다.

## 1줄 설치 명령어

```bash
git clone -b feat/huggingface-model-support https://github.com/huiseo/term-code.git && cd term-code/claude-code && chmod +x *.sh && ./install-ollama-huggingface.sh && ./huggingface-model-import.sh TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf tinyllama:1.1b
```

## 단계별 설치

### 1. 특정 브랜치 클론
```bash
# feat/huggingface-model-support 브랜치를 직접 클론
git clone -b feat/huggingface-model-support https://github.com/huiseo/term-code.git
cd term-code/claude-code
```

### 2. 스크립트 실행 권한 부여
```bash
chmod +x *.sh
```

### 3. Ollama 설치 (GitHub에서 다운로드)
```bash
./install-ollama-huggingface.sh
```

### 4. 모델 설치 (Hugging Face에서 다운로드)
```bash
# 가벼운 모델 (668MB)
./huggingface-model-import.sh TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf tinyllama:1.1b
```

### 5. 테스트
```bash
# 모델 목록 확인
ollama list

# 모델 실행
ollama run tinyllama:1.1b
```

## 직접 다운로드 링크

브랜치 전체를 ZIP으로 다운로드:
https://github.com/huiseo/term-code/archive/refs/heads/feat/huggingface-model-support.zip

## 주요 파일들

- `install-ollama-huggingface.sh` - Ollama 설치 스크립트
- `huggingface-model-import.sh` - 모델 가져오기 스크립트
- `HUGGINGFACE_MODELS.md` - 상세 가이드

## 문제 해결

### Windows/WSL에서 실행 시
```bash
# 줄바꿈 변환
sudo apt-get install dos2unix
dos2unix *.sh
```

### 권한 문제 발생 시
```bash
# sudo 권한으로 Ollama 설치
sudo bash install-ollama-huggingface.sh
```

## 추가 모델

더 많은 모델을 사용하려면 `HUGGINGFACE_MODELS.md` 파일을 참조하세요.