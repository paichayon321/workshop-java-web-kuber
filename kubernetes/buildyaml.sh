#!/bin/sh
cat <<EOF> deployapp.yaml
apiVersion: v1
kind: Service
metadata:
  name: demoapp
spec:
  selector:
    app: demoapp
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
---

apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: demoapp
  labels:
    app: demoapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: demoapp
  template:
    metadata:
      labels:
        app: demoapp
    spec:
      containers:
      - name: demoapp
        image: $IMAGE_NAME:$BUILD_NUMBER
        imagePullPolicy: Always
        ports:
        - containerPort: 8080
      imagePullSecrets:
      - name: regcred
EOF

