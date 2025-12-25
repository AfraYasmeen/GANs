FROM python:3.10-slim

WORKDIR /app

# install system deps
RUN apt-get update && apt-get install -y git build-essential && rm -rf /var/lib/apt/lists/*

# copy project
COPY . /app

# install python deps
RUN pip install --upgrade pip && pip install -r requirements.txt

CMD ["python", "src/generate_images_from_prompt.py", "--help"]
