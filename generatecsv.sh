#! /bin/sh
echo "Welcome to Kano State Kigra Sifmis Bridge System"

#Login into the database
#Define  variable to hold the date
#Execute a query
echo "Login into the database..."

yesterday=$( date -d "yesterday 13:00 " '+%Y-%m-%d' )


/bin/sqlite3 /home/exponent/code/php/kanosifmis/database/database.sqlite <<EOF
.headers on
.mode csv
.output ${yesterday}.csv
SELECT id, txnId, validationNumber, amount, customerName, revenueHead, bankName, paymentMethod, paymentDate, 
	created_at FROM transactions WHERE  qdate=DATE('now','-1 day') AND processed='0';
EOF

chmod 777 "$yesterday".csv

#Assign owner of the file to 
#chown applprod "$yesterday".csv

#move the file to AR_TOP

mv "$yesterday".csv $AR_TOP/"$yesterday".csv

cd $AR_TOP

if[-x "$yesterday".csv]; then
	/bin/sqlite3 /home/exponent/code/php/kanosifmis/database/database.sqlite <<EOF
	UPDATE transactions SET processed=1 WHERE  qdate=DATE('now','-1 day') AND processed=0
EOF

echo "Database Operations done successfully"

