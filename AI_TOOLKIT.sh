#!/bin/bash
# Set your huggingface read api key as MYHFKEY on the https://cloud.vast.ai/account/ (Settings - Environment Variables)
# Open https://huggingface.co/black-forest-labs/FLUX.1-Kontext-dev and press button "Agree and accept this repository"

#set -euo pipefail  # Останавливать выполнение при ошибках

cd /workspace/

echo "==> Creating AI Toolkit startup script..."
# Создаём скрипт запуска ai-toolkit
cat << 'EOF' > /workspace/runaitoolkit.sh
#!/bin/bash
cd /workspace/ai-toolkit
source venv/bin/activate
npm --prefix /workspace/ai-toolkit/ui run build_and_start
EOF
chmod +x /workspace/runaitoolkit.sh

echo "==> Creating model download script..."
# Создаём скрипт скачивания модели с отметкой о завершении
cat << 'EOF' > /workspace/download_fluxkontext.sh
#!/bin/bash
python -c "from huggingface_hub import snapshot_download; snapshot_download(repo_id='Aitrepreneur/text-dev')" > /workspace/modeldownload.log 2>&1
if [ $? -eq 0 ]; then
  touch /workspace/fluxkontext.ok
  echo "Model download completed successfully!"
else
  echo "Model download failed. Check /workspace/modeldownload.log"
fi
EOF
chmod +x /workspace/download_fluxkontext.sh

echo "==> Cloning AI Toolkit repository..."
# Клонируем репозиторий (проверяем, не существует ли уже)
if [ ! -d "/workspace/ai-toolkit" ]; then
  git clone https://github.com/ostris/ai-toolkit.git /workspace/ai-toolkit
else
  echo "AI Toolkit already exists, skipping clone..."
fi

echo "==> Setting up Python virtual environment..."
# Переходим в папку и создаём виртуальное окружение
cd /workspace/ai-toolkit
python3 -m venv venv
source venv/bin/activate

echo "==> Installing PyTorch..."
# Устанавливаем PyTorch с нужной версией CUDA
pip3 install --no-cache-dir torch==2.7.0 torchvision==0.22.0 torchaudio==2.7.0 --index-url https://download.pytorch.org/whl/cu126

echo "==> Installing requirements..."
# Устанавливаем остальные зависимости
pip3 install -r requirements.txt

# Проверяем успешность установки и запускаем AI Toolkit
if [ $? -eq 0 ]; then
  echo "==> Installation completed successfully!"
  touch /workspace/aitoolkitrequirements.ok
  
  echo "==> Starting AI Toolkit..."
  # Запускаем в фоне, чтобы скрипт не блокировался
  nohup /workspace/runaitoolkit.sh > /workspace/aitoolkit.log 2>&1 &
  
  echo "AI Toolkit started in background. Check logs at /workspace/aitoolkit.log"
  echo "You can also start it manually: /workspace/runaitoolkit.sh"
  echo "Download model with: /workspace/download_fluxkontext.sh"
else
  echo "==> Installation failed!"
  exit 1
fi

echo "==> Setup complete!"
