#!/bin/bash
#set your huggingface read api key as MYHFKEY on the https://cloud.vast.ai/account/ (Settings - Environment Variables)
#open https://huggingface.co/black-forest-labs/FLUX.1-Kontext-dev and press a button Agree and accept this repository
cd /workspace/
mkdir tesflag
git clone https://github.com/ostris/ai-toolkit.git
cd ai-toolkit
python3 -m venv venv
source venv/bin/activate
# install torch first
pip3 install --no-cache-dir torch==2.7.0 torchvision==0.22.0 torchaudio==2.7.0 --index-url https://download.pytorch.org/whl/cu126
pip3 install -r requirements.txt

nohup python -c 'from huggingface_hub import snapshot_download; snapshot_download(repo_id="rusauron/aitoolkit-8bit-FLUX.1-Kontext-dev")' > /workspace/modeldownload.log 2>&1 &

cd ui
AI_TOOLKIT_AUTH=myPasS npm run build_and_start
