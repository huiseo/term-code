# Hugging Face 모델 사용 가이드

이 문서는 ollama.com 접속 없이 Hugging Face에서 직접 모델을 다운로드하여 사용하는 방법을 설명합니다.

## 1. Ollama 설치 (ollama.com 접속 없이)

```bash
# GitHub에서 직접 다운로드
./install-ollama-huggingface.sh
```

## 2. Hugging Face에서 GGUF 모델 가져오기

### 방법 1: 제공된 스크립트 사용

```bash
# 스크립트 실행 권한 부여
chmod +x huggingface-model-import.sh

# 모델 다운로드 및 가져오기
./huggingface-model-import.sh <repo> <file> <name>
```

### 방법 2: 수동으로 모델 가져오기

1. Hugging Face에서 GGUF 모델 찾기:
   - https://huggingface.co/models?search=gguf&sort=trending
   
2. 모델 다운로드:
   ```bash
   wget https://huggingface.co/<repo>/resolve/main/<model>.gguf
   ```

3. Modelfile 생성:
   ```bash
   echo "FROM /path/to/model.gguf" > Modelfile
   ```

4. Ollama에 모델 등록:
   ```bash
   ollama create mymodel -f Modelfile
   ```

## 3. 추천 모델 목록

### 소형 모델 (빠른 응답)
- **TinyLlama 1.1B**: 가벼운 채팅 모델
  ```bash
  ./huggingface-model-import.sh TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf tinyllama:1.1b
  ```

### 코딩 특화 모델
- **CodeLlama 7B**: 코드 생성 특화
  ```bash
  ./huggingface-model-import.sh TheBloke/CodeLlama-7B-GGUF codellama-7b.Q4_K_M.gguf codellama:7b
  ```

- **DeepSeek Coder**: 프로그래밍 특화
  ```bash
  ./huggingface-model-import.sh TheBloke/deepseek-coder-1.3b-instruct-GGUF deepseek-coder-1.3b-instruct.Q4_K_M.gguf deepseek-coder:1.3b
  ```

### 범용 모델
- **Mistral 7B**: 균형잡힌 성능
  ```bash
  ./huggingface-model-import.sh TheBloke/Mistral-7B-v0.1-GGUF mistral-7b-v0.1.Q4_K_M.gguf mistral:7b
  ```

## 4. 모델 사용하기

### Term-Code에서 사용
```bash
# 모델 목록 확인
tcode ollama:list

# 특정 모델 선택
tcode ollama:use tinyllama:1.1b

# 코드 관련 질문
tcode ask "Python에서 이진 탐색 구현 방법은?"
```

### 직접 Ollama 사용
```bash
# 모델 실행
ollama run tinyllama:1.1b

# 모델 목록
ollama list

# 모델 삭제
ollama rm modelname
```

## 5. 문제 해결

### Ollama 서비스가 실행되지 않을 때
```bash
# 서비스 상태 확인
systemctl status ollama

# 수동으로 실행
ollama serve
```

### 모델 다운로드가 느릴 때
- Hugging Face 미러 사이트 사용
- 더 작은 양자화 버전 선택 (Q4_K_M 대신 Q3_K_S)
- 프록시 설정 확인

## 6. 추가 리소스

- GGUF 모델 검색: https://huggingface.co/models?search=gguf
- TheBloke's models: https://huggingface.co/TheBloke
- Ollama 모델 포맷 문서: https://github.com/ollama/ollama/blob/main/docs/modelfile.md