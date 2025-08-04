# MongoDB Backup
mongodump --host mongodb --out /backup/mongo-$(date +%F)

# Restore
mongorestore --host mongodb /backup/mongo-YYYY-MM-DD
