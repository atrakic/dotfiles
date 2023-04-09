https://kubernetes.io/docs/tasks/debug-application-cluster/debug-running-pod/
# kubectl run myapp --image=busybox --restart=Never -- sleep 1d

# kubectl run -i --tty busybox --image=busybox -- sh
kubectl run busybox -it --rm --image=busybox --restart=Never sh
