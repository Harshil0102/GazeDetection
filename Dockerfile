# Use the official Python image from the Docker Hub
FROM python:3.11-slim

# Install system dependencies for dlib
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    libopenblas-dev \
    liblapack-dev \
    libx11-dev \
    libgtk-3-dev \
    wget

# Set the working directory
WORKDIR /app

# Copy the requirements file into the image
COPY requirements.txt .

# Install the Python dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Download and install dlib from the provided .whl file
RUN wget https://github.com/z-mahmud22/Dlib_Windows_Python3.x/raw/main/dlib-19.24.1-cp311-cp311-win_amd64.whl -O dlib.whl && \
    pip install dlib.whl && \
    rm dlib.whl

# Copy the rest of the application into the image
COPY . .

# Download and install the dlib model file
RUN wget http://dlib.net/files/shape_predictor_68_face_landmarks.dat.bz2 && \
    bzip2 -d shape_predictor_68_face_landmarks.dat.bz2 && \
    mv shape_predictor_68_face_landmarks.dat /app

# Set the entry point for the container
CMD ["gunicorn", "-w", "3", "-b", "0.0.0.0:80", "app:app"]
