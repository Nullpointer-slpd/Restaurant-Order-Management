#!/bin/bash
# For analysis of the restaurant's performance
#MENU_FILE="./Menu.txt"
ORDER_FILE="./Order.txt"
hourly_analysis_for_the_given_date_and_hour() {
    local hour=$1
    local date=$2
    #+substr($3,1,2)==+hour : + added to convert the variables into their respective numerical equivalent
    awk -F '|' -v hour="$hour" -v date="$date" '$2==date && +substr($3,1,2)==+hour' "$ORDER_FILE" | awk -F '|'\
        '{amount[$1]+=$6} END {
            sum = 0;
            count = 0;
            for ( a in amount){
                count++;
                if (amount[a]>50)
                    amount[a]-= (0.1)*amount[a];
                sum+=amount[a];
            }
        if (count!=0){
            print "Total Hourly sale : ₹" sum,"No. of orders :",count
            print "\nAverage Spending : ₹" (sum/count)
        }else{
            print "Total Hourly sale : ₹0","No. of orders :0"
            }
        }'
}
sales_by_category() {
    awk -F '|' ' NR>1 {category[$7]+=$6} END
                 {for (c in category)
            print "Category : ",c " ; Sale : ₹" category[c]}' "$ORDER_FILE"
}
read -p "Enter the date for which you want the analysis for(DD-MM-YYYY format) : " input_date
echo "Do want the analysis for only a specified HOUR or for a specified INTERVAL?"
read -p "Enter 'h' for hour and 'i' for interval. Enter 's' to skip : " input
    if [[ $input == 'h' ]];then
        read -p "Enter the hour for which you want the analysis for(24H format) : " input_hour
        hourly_analysis_for_the_given_date_and_hour "$input_hour" "$input_date"
    elif [[ $input == 'i' ]]; then
        read -p "Enter the start and end hour of the interval(24H format) : " start_hour end_hour
        max_sum=0
        peak_hour=""
        for ((i=start_hour; i<=end_hour; i++ ));do
            echo "-----------------------------"
            echo "Hour = $i"
            output=$(hourly_analysis_for_the_given_date_and_hour "$i" "$input_date")
            echo "$output"

            current_sum=$(echo "$output" | grep "Total Hourly sale" | awk -F '₹' '{print $2}' | awk '{print $1}') 
            #last command added to chop off any invisible spaces (tr -d '[:space]')
            if [[ -z $current_sum || ! "$current_sum" =~ ^[0-9]+(\.[0-9]+)?$ ]];then #to assign zero to current_sum if its an invalid number
                current_sum=0
            fi
            if awk "BEGIN {exit !($current_sum > $max_sum)}";then
                max_sum="$current_sum"
                peak_hour="$i"
            fi
        done
            echo "=========================="
            if [[ -z "$peak_hour" || "$max_sum" == "0" ]];then
            echo "No sales in this interval"
            else
            echo "Peak performance : Hour $peak_hour with ₹$max_sum in sales"
            fi
    elif [[ "$input" == 's' ]];then
        :#Do nothing
    else 
        echo "Invalid input" >&2
    fi
read -p "Do you want to check category-wise sales(Overall,without accounting for discount)? [y/n] : " category_sales
if [[ "$category_sales" == 'y' ]];then
    sales_by_category
elif [[ "$category_sales" == 'n' ]];then
    : #Do nothing
else
    echo "Invalid Input"
fi