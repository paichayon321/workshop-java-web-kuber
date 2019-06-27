#!/bin/sh
cat <<EOF> deployingress.yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/app-root: "/demo/"
  name: demoapp-ingress
spec:
  rules:
  - host: $ACCESS_URL
    http:
      paths:
      - path: /
        backend:
          serviceName: demoapp
          servicePort: 80
EOF

