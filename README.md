# Restaurant Order Management System
#### A command-line restaurant order management system developed using Bash Shell Scripting. This project can help restaurant staff and managers control customer orders, apply and calculate bills and discounts while analyzing restaurant sales. 


## Features
### Order Management

- Displays the restaurant menu with its item IDs and prices for customer viewing. 
- Allows the customers to select multiple food items as they wish. 
- Validates the item ID input of the food items selected. 
- Confirms the orders before processing them. 
- Generates a unique bill number for each order.
- Stores the order details for future reference for the restaurant.

### The Billing System

- Automatically calculates the total order amount.
- Automatically applies a 10% discount when the total exceeds ₹50.
- Displays the final total order amount after the 10% discount. 


### Sales Analysis
- Calculates the hourly sales for a selected date/day. 
- Analyze the total sales over a specified time interval.
- Can identify the peak sales hour(/s).
- Displays the number of orders and the average spending of a customer.
- Generates the category wise sales summaries for each item.


### Order Editing
- Allow customers to change the confirmed orders before the final billing section.
- Allows them to replace previously ordered items with other available menu items.
- Helps validate the item IDs and ensures that the items belong to the current order.


### Tools and Technologies Used

- **Bash** – Main scripting language
- **AWK** – Data processing and sales analysis
- **Linux/Unix Shell** – Execution environment
- **Text Files** – Data storage
- **Git & GitHub** – Version control

### Project Skeleton Structure

```text
Restaurant-Order-Management/
├── Server.sh
├── Manager.sh
├── Menu.txt
├── Order.txt
└── README.md
```


## File Descriptions

| File | Description |
|------|-------------|
| `Server.sh` | Handles order placement, billing, and discounts |
| `Manager.sh` | Performs restaurant sales analysis |
| `Menu.txt` | Stores menu items and their details |
| `Order.txt` | Stores customer order records |
| `README.md` | Project documentation |

## Installation and Setup

### Prerequisites

- Linux or a compatible Bash environment
- Bash
- AWK
- bc
- column
- Git (for the cloning step)


## How It Works

### Order Processing

1. The restaurant menu is displayed to the customer.

2. The user selects the items that they want using their item IDs.

3. The system validates the input (items that are selected) and requests confirmation from the customer.

4. The total bill is calculated based on the selected items.

5. An eligible discount is applied based on the total bill and if the customer is eligible for it.

6. The order details are saved in Order.txt.

## How to Run

```bash
# 1. Clone the repository
git clone https://github.com/Nullpointer-slpd/Restaurant-Order-Management.git

# 2. Navigate to the project directory
cd Restaurant-Order-Management

# 3. Run the order management system
bash Server.sh

# 4. Run the sales analysis system
bash Manager.sh
```

Order details are stored in `Order.txt`, while menu information is maintained in `Menu.txt`.

### Sales Analysis

1. The manager enters a date for analysis.

2. The manager chooses between the hourly or interval-based analysis.

3. The system calculates the sales and the order statistics for that interval.

4. The manager can view category wise sales also.

### Future Improvements

- Can add a menu management functionality.
- Add a quantity selection feature to allow customers to order multiple units of the same food item.
- Improve the input validation and the error handling.
- Could generate a detailed daily and monthly sales reports including revenue breakdowns, order trends of best-selling items, peak business hours, etc.
- Could introduce a graphical user interface to make it simpler for all users (customers and restaurant managers).


## Repository

https://github.com/Nullpointer-slpd/Restaurant-Order-Management
