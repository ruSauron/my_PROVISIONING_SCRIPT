#!/bin/bash
#set your huggingface read api key as MYHFKEY on the https://cloud.vast.ai/account/ (Settings - Environment Variables)
#open https://huggingface.co/black-forest-labs/FLUX.1-Kontext-dev and press a button Agree and accept this repository
cd /workspace/
echo -e '#!/bin/bash\n\nwhile [ ! -f /workspace/aitoolkitrequirements.ok ]; do\n  echo "Waiting for /workspace/aitoolkitrequirements.ok..."\n  sleep 10\n  if pgrep -f "npm --prefix /workspace/ai-toolkit/ui run build_and_start" > /dev/null; then\n    echo "Process already running, exiting."\n    exit 1\n  fi\ndone\n\nnpm --prefix /workspace/ai-toolkit/ui run build_and_start' > /workspace/aitoolkit.sh && chmod +x /workspace/aitoolkit.sh
nohup bash -c "sudo apt update && sudo apt install -y nodejs npm" > nodejs_install.log 2>&1 &
git clone https://github.com/ostris/ai-toolkit.git
cd ai-toolkit
python3 -m venv venv
source venv/bin/activate
# install torch first
pip3 install --no-cache-dir torch==2.7.0 torchvision==0.22.0 torchaudio==2.7.0 --index-url https://download.pytorch.org/whl/cu126
pip3 install -r requirements.txt
touch /workspace/aitoolkitrequirements.ok
#pip3 install hf_xet
#nohup python -c 'from huggingface_hub import snapshot_download; snapshot_download(repo_id="rusauron/aitoolkit-8bit-FLUX.1-Kontext-dev")' > /workspace/modeldownload.log 2>&1 &
#nohup python -c 'from huggingface_hub import snapshot_download; snapshot_download(repo_id="black-forest-labs/FLUX.1-Kontext-dev")' > /workspace/modeldownload.log 2>&1 &
echo -e '#!/bin/bash\npython -c "from huggingface_hub import snapshot_download; snapshot_download(repo_id=\"Aitrepreneur/text-dev\")" > /workspace/modeldownload.log 2>&1\nif [ $? -eq 0 ]; then\n  touch /workspace/fluxkontext.ok\nfi' > /workspace/download_fluxkontext.sh && chmod +x /workspace/download_fluxkontext.sh
#nohup bash -c "cd /workspace/ai-toolkit/ui && AI_TOOLKIT_AUTH=myPasS npm run build_and_start" > ai-toolkit.log 2>&1 &
#echo -e '#!/bin/bash\ncd /workspace/ai-toolkit/ui\nnpm run build_and_start' > /workspace/aitoolkit.sh && chmod +x /workspace/aitoolkit.sh
#echo -e '#!/bin/bash\nnpm --prefix /workspace/ai-toolkit/ui run build_and_start' > /workspace/aitoolkit.sh && chmod +x /workspace/runaitoolkit.sh
