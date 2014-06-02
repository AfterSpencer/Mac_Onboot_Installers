#!/bin/sh

applicationreceipts=(
/Applications/iMovie.app/Contents/_MASReceipt/receipt
/Applications/GarageBand.app/Contents/_MASReceipt/receipt
/Applications/Pages.app/Contents/_MASReceipt/receipt
/Applications/iPhoto.app/Contents/_MASReceipt/receipt
/Applications/Numbers.app/Contents/_MASReceipt/receipt
/Applications/Keynote.app/Contents/_MASReceipt/receipt
/Applications/iBooks\ Author.app/Contents/_MASReceipt/receipt
)

for receipt in "${applicationreceipts[@]}"
do

if [ -e $3"$receipt" ]
then
echo "Removing $receipt"
rm -r $3"$receipt"
else
echo "$receipt doesn't exist!"
fi
done

