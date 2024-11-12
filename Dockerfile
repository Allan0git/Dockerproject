# Use Python 3.8 slim image
FROM python:3.8-slim

# Set the working directory
WORKDIR /app

# Copy current directory contents into the container
COPY . /app

# Install dependencies from requirements.txt, if available
COPY requirements.txt ./
RUN pip install -r requirements.txt

# Install Flask (in case it's not listed in requirements.txt)
RUN pip install flask

# Expose port 80 for the application
EXPOSE 80

# Run the application
CMD ["python", "app.py"]
