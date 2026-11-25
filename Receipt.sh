#!/bin/bash
#for generating receipts of the orders. 
ORDER_FILE="./Order.txt"
RECEIPT_DIR="./Receipts"
generate_receipt() {
    local bill_no=$1
    local subtotal=$2
    local discount=$3
    local amount=$4
    mkdir -p "$RECEIPT_DIR"||return 1 #creates the directory if it doesnt already exist. 

    local receipt_file="$RECEIPT_DIR/Receipt_$bill_no.txt"
    # helps retreive the items belonging to that bill
    local records
    records=$(awk -F '|' -v id="$bill_no" 'NR > 1 && $1 == id' "$ORDER_FILE")
    if [[ -z "$records" ]]; 
    then
        echo "Error: The bill you are looking for could not be found. Please try again later."
        return 1
    fi
    # retrieve the time and date of that bill. 
    local bill_date bill_time
    bill_date=$(echo "$records" | awk -F '|' 'NR==1 {print $2}')
    bill_time=$(echo "$records" | awk -F '|' 'NR==1 {print $3}')
    # diplay and save the receipt.
    {
        echo " "
        echo "--------------------------------------------"
        echo "             RESTAURANT RECEIPT"
        echo "--------------------------------------------"
        echo "Bill Number: $bill_no"
        echo "Date: $bill_date"
        echo "Time: $bill_time"
        echo "--------------------------------------------"
        {
            echo "ItemID|Name|Price|Category"
            echo "$records" | cut -d '|' -f 4-7
        } | column -t -s '|'
        echo "--------------------------------------------"
        printf "Subtotal:       Rs.%.2f\n" "$subtotal"
        printf "Discount:       Rs.%.2f\n" "$discount"
        printf "Final Amount:   Rs.%.2f\n" "$amount"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo " Thank you for visiting! Come Again Soon!!"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo " "

    } | tee "$receipt_file"
    if [[ ${PIPESTATUS[1]} -eq 0 ]]; 
    then
        echo "Receipt is saved to $receipt_file successfully"
    else
        echo "Error: Unable to save receipt successfully." >&2
        return 1
    fi
}

retrieve_receipt() {
    local bill_no
    read -r -p "Enter Bill Number: " bill_no
    if [[ ! "$bill_no" =~ ^[0-9]{3,}$ ]]; 
    then
        echo "Error: Invalid bill number."
        return 1
    fi
    local receipt_file="$RECEIPT_DIR/Receipt_$bill_no.txt"
    if [[ -f "$receipt_file" ]]; 
    then
        cat "$receipt_file"
    else
        echo "Error: No saved receipt found for Bill $bill_no."
        return 1
    fi
}

# determinee which operation to perform. 
case "$1" in
    generate)
        if [[ $# -ne 5 ]]; then
            echo "Error: There is missing bill information. "
            exit 1
        fi

        generate_receipt "$2" "$3" "$4" "$5"
        ;;
    "")
        retrieve_receipt
        ;;
    *)
        echo "Error: Invalid operation."
        exit 1
        ;;
esac
