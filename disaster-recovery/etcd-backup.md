# Etcd Backup and Restore

# Backup
ETCDCTL_API=3 etcdctl snapshot save snapshot.db

# Restore
ETCDCTL_API=3 etcdctl snapshot restore snapshot.db

