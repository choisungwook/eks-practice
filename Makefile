install:
	@eksctl create cluster -f 01_create_eks_cluster/cluster.yaml

uninstall:
	@eksctl delete cluster --name basic-cluster
