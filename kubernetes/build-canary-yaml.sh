#!/bin/sh
cat <<EOF> deployapp-canary.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: demoapp-canary
  labels:
    app: demoapp-canary
    track: canary
spec:
  replicas: 1
  selector:
    matchLabels:
      app: demoapp
  template:
    metadata:
      labels:
        app: demoapp
        track: canary
    spec:
      containers:
      - name: demoapp
        image: $IMAGE_NAME:$BUILD_NUMBER
        ports:
        - containerPort: 8080
EOF
