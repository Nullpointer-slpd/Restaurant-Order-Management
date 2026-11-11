#!/bin/bash
MENU_FILE="./Menu.txt"
ORDER_FILE="./Order.txt"
check_if_Menu_exists() {
    if [ -f "$MENU_FILE" ];then
        :
    else
        echo "Menu file doesn't exist in this directory. Please retry"
        return 1;
    fi
}
is_valid_order() {
    local input=$1
    if [[ "$input" =~ ^[0-9]{3}$ ]]; then
        if awk -F '|' -v id="$o" '$1==id {found=1; exit} END {exit !found}' "$MENU_FILE"; then
        # if found = 0, exit 1 indicates failure (i.e, not found). if found = 1, exit 0 indicates success
            return 0;
        else
            echo "Invalid ItemID entered"
        fi
            return 1
    else
        echo "TypeError : Invalid order" >&2
        return 1
    fi
}
calculate_cost() {
    sum=0
    for o in "${orders[@]}";do 
        local price
        price=$(grep -w "$o" $MENU_FILE | awk -F '|' '{print $3}')
        if [[ -n "$price" ]]; then #-n : non-zero length string , -z : zero length string
            sum=$(awk "BEGIN {print $price + $sum}")
        fi
    done
    echo "Total cost : $sum"
}
is_eligible_for_discount() {
    local check;
    check=$(awk "BEGIN {print ($sum > 50 ? 1 : 0)}") #since direct decimal comparisons are not supported by bash
    if [[ $check -eq 1 ]];then
        echo "Applicable for discount"
    else
        echo "Not applicable for discount"
        amount=$sum
        return 0;
    fi
    discount=$(echo "scale=2; (10/100)*$sum" | bc);
    echo "Discount amount = $discount"
    amount=$(echo "scale=2; $sum - $discount" |bc)
}
store_orders() {
    date=$(date '+%d-%m-%Y')
    time=$(date '+%H-%M')
    if [[ -f "$ORDER_FILE" && -s "$ORDER_FILE" ]]; then #to check if the order file exists
        last_id=$(tail -n 1 "$ORDER_FILE" | awk -F '|' '{print $1}') # Storing the Bill No of the last order
        BillNo=$(printf "%03d" $((10#$last_id+1))) #10# added so that bash avoid reading values like 008 as octal
    else
        echo "BillNo|Date|Time|ItemID|Name|Price(₹)|Category"  > "$ORDER_FILE"
        BillNo=001  #For the first order
    fi
    for o in "${orders[@]}"; do
        line=$(grep -w "$o" "$MENU_FILE")
        echo "$BillNo|$date|$time|$line" >> "$ORDER_FILE"    # > : overwrites existing content ;  >> : appends at the end
    done
}
# To display the menu
check_if_Menu_exists
awk 1 "$MENU_FILE" | column -t -s '|'
echo
echo 
declare -a orders
while true; do
    while true; do 
        IFS=', ' read -r -a orders -p "Enter Item ID for the item you want to order. Separate either by commas or spaces, NOT BOTH : "
        all_not_valid=0;
        for o in "${orders[@]}";do 
            if is_valid_order "$o"; then 
                continue;
            else
                echo "Please enter your order again"
                all_not_valid=1
                break;
            fi
        done
        if [[ "$all_not_valid" -eq 0 ]];then
            break;
        fi;
    done
    read -p "Confirm order?[y/n] : " input
    if [[ $input == 'y' ]];then
        break;
    fi
done
if [ "${#orders[@]}" -eq 0 ];then #no of valid orders = 0
    echo "No items ordered. Exiting"
    exit 0
fi
store_orders 
# Ordered items
echo "-------------------------"
echo "Your order : "
{
awk 'NR==1 {print }' $MENU_FILE 
for o in "${orders[@]}"; do
    awk -F '|' -v id="$o" '$1==id' "$MENU_FILE" #to avoid the clashing of ItemID with Prices
done
}| column -t -s '|'
calculate_cost
is_eligible_for_discount
echo "Total amount after discount : $amount"
echo "*----------------------------------------------------*"
echo "Thank you for visiting our restaurant! Hope you had a great time"

