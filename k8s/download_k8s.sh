#!/bin/bash
set -eo pipefail

BASEPATH=/opt/kbox/k8s/kube

echo "Downloading server binaries ..."
curl --progress-bar -L https://dl.k8s.io/$1/kubernetes-server-linux-amd64.tar.gz -o /tmp/kube-linux-amd64-$1.tar.gz
echo "Downloading kubectl binary for mac ..."
curl --progress-bar -L https://dl.k8s.io/$1/kubernetes-client-darwin-amd64.tar.gz -o /tmp/kubectl.tar.gz
tar -xvf /tmp/kubectl.tar.gz -C $BASEPATH
tar -xvf /tmp/kube-linux-amd64-$1.tar.gz -C $BASEPATH

mv $BASEPATH/kubernetes/server/bin/kube-apiserver $BASEPATH/
mv $BASEPATH/kubernetes/server/bin/kube-controller-manager $BASEPATH/
mv $BASEPATH/kubernetes/server/bin/kube-proxy $BASEPATH/
mv $BASEPATH/kubernetes/server/bin/kube-scheduler $BASEPATH/
mv $BASEPATH/kubernetes/server/bin/kubelet $BASEPATH/
mv $BASEPATH/kubernetes/client/bin/kubectl /opt/kbox/k8s/kubectl
rm -f /opt/kbox/k8s/kube.tgz
rm -rf $BASEPATH/kubernetes
chmod +x /opt/kbox/k8s/kubectl

echo ""
echo "Packing it ..."
COPYFILE_DISABLE=1 tar -czf /opt/kbox/k8s/kube.tgz -C kube .

echo ""
echo "Clean up ..."
rm -f $BASEPATH/kube-apiserver
rm -f $BASEPATH/kube-controller-manager
rm -f $BASEPATH/kube-proxy
rm -f $BASEPATH/kube-scheduler
rm -f $BASEPATH/kubelet
echo "Done."

