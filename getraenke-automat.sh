#!/bin/bash

#-------------------------------------------------
# Author:               Luca Fabian Burger
# Organisation          IMS
# Version:              1.7
# Task:                 Beverage Vending Machine
# OS:                   Linux (arch) native
# Date:                 21.5.24
# Last added feature:   Improved Input handles
# Start                 ./getraenke-automat.sh
# start from root       ./startGetraenke.sh    
#-------------------------------------------------

running=0
balance=0
selected_milk=""
selected_sugar=""
beverage=""
original_price=0
daily_sales=()  # Array to store daily sales

# Function to ensure non-empty input
read_non_empty() {
    local prompt="$1"
    while true; do
        read -p "$prompt" input
        if [ -n "$input" ]; then
            break
        else
            echo "Input cannot be empty. Please enter a valid option."
        fi
    done
}

# Function to start the machine
start_machine(){
    clear
    is_machine_active=0
    while [ $is_machine_active -ne 1 ]; do
        read_non_empty "Press 1 to start the machine: "
        sleep 4
        clear
        sleep 2
        if [ $input -eq 1 ]; then
            is_machine_active=1
        fi
    done
}

# Function to get beverage input
get_beverage() {
    echo "Beverage Vending Machine Menu:"
    echo "1) Cafe"
    echo "2) Tea"
    echo "3) Sprite"
    echo "4) Fanta"
    echo "5) Mineral Water"
    echo "6) Cola"
    echo "7) Cigarettes"
    read_non_empty "What would you like? (-1 to Cancel): "
}

# Function to get cafe input
get_cafe() {
    echo "Cafe Menu:"
    echo "1) Espresso"
    echo "2) Latte Machiato"
    echo "3) Coffee"
    read_non_empty "What kind of cafe would you like? "
}

# Function to get tea input
get_tea() {
    echo "Tea Menu:"
    echo "1) Schwarztee"
    echo "2) Grüntee"
    echo "3) Jasmintee"
    echo "4) Vanille Tee"
    read_non_empty "What kind of tea would you like? "
}

# Function to get cigarette input
get_cigarettes() {
    echo "Cigarette Menu:"
    echo "1) Chetserfield"
    echo "2) Malboro"
    echo "3) Camel"
    echo "4) Winston"
    echo "5) Lucky Strike"
    read_non_empty "What brand of cigarettes would you like? "
}

# Function to get mineral water input
get_mineral_water() {
    echo "Mineral Water Menu:"
    echo "1) With gas"
    echo "2) Without gas"
    read_non_empty "Do you want mineral water with or without gas? "
}

# Function to get cola input
get_cola() {
    echo "Cola Menu:"
    echo "1) Normal"
    echo "2) Light"
    echo "3) Zero"
    read_non_empty "What kind of cola would you like? "
}

# Function to get yes or no input
get_y_n(){
    read_non_empty "Yes or no? (y/n): "
}

# Function to get milk selection
get_milk(){
    echo "Do you want some milk?"
    get_y_n
    if [ "$input" == "y" ]; then
        echo "1) cow-milk"
        echo "2) oat-milk"
        echo "3) almond-milk"
        echo "4) rice-milk"
        echo "5) no-milk"
        read_non_empty "What kind of milk would you like? "
        case $input in
            1) selected_milk="cow-milk" ;;
            2) selected_milk="oat-milk" ;;
            3) selected_milk="almond-milk" ;;
            4) selected_milk="rice-milk" ;;
            5) selected_milk="no-milk" ;;
            *) echo "Invalid input";;
        esac
    else
        echo "No milk selected"
    fi
}

# Function to get sweetener selection
get_sugar(){
    echo "Do you want some sweetener?" 
    get_y_n
    if [ "$input" == "y" ]; then
        echo "1) sugar"
        echo "2) brown sugar"
        echo "3) stevia"
        echo "4) no-sweetener"
        read_non_empty "What kind of sweetener would you like? "
        case $input in
            1) selected_sugar="sugar" ;;
            2) selected_sugar="brown sugar" ;;
            3) selected_sugar="stevia" ;;
            4) selected_sugar="no-sweetener" ;;
            *) echo "Invalid input";;
        esac
    else
        echo "No sweetener selected"
    fi
}

# Function to get modifications for the beverage
get_modifications(){
    get_milk
    get_sugar
}

# Function to handle cafe selection
select_cafe() {
    get_cafe
    case $input in
        1)
            echo "You have chosen Espresso"
            beverage="Espresso"
            original_price=2
            ;;
        2)
            echo "You have chosen Latte Machiato"
            beverage="Latte Machiato"
            original_price=5
            ;;
        3)
            echo "You have chosen Coffee"
            beverage="Coffee"
            original_price=3
            ;;
        *)
            echo "Invalid input"
            ;;
    esac
}

# Function to handle tea selection
select_tea() {
    get_tea
    case $input in
        1)
            echo "You have chosen Schwarztee"
            beverage="Schwarztee"
            original_price=2
            ;;
        2)
            echo "You have chosen Grüntee"
            beverage="Grüntee"
            original_price=3
            ;;
        3)
            echo "You have chosen Jasmintee"
            beverage="Jasmintee"
            original_price=3
            ;;
        4)
            echo "You have chosen Vanille Tee"
            beverage="Vanille Tee"
            original_price=4
            ;;
        *)
            echo "Invalid input"
            ;;
    esac
}

# Function to handle cigarette selection
select_cigarettes() {
    get_cigarettes
    case $input in
        1)
            echo "You have chosen Chetserfield"
            beverage="Chetserfield"
            original_price=10
            ;;
        2)
            echo "You have chosen Malboro"
            beverage="Malboro"
            original_price=12
            ;;
        3)
            echo "You have chosen Camel"
            beverage="Camel"
            original_price=9
            ;;
        4)
            echo "You have chosen Winston"
            beverage="Winston"
            original_price=8
            ;;
        5)
            echo "You have chosen Lucky Strike"
            beverage="Lucky Strike"
            original_price=11
            ;;
        *)
            echo "Invalid input"
            ;;
    esac
}

# Function to handle payment
handle_payment() {
    total_payment=0
    while [ $total_payment -lt $balance ]; do
        read_non_empty "Initial price $balance CHF. Please insert coins or bills (Enter -1 to cancel): "
        payment=$input
        if [ $payment -eq -1 ]; then
            echo "Cancelling the transaction..."
            echo "Returning your payment..."
            sleep 2
            echo "Transaction cancelled."
            balance=$((balance - total_payment))
            return 1  # Return 1 to indicate cancellation
        elif [ $payment -lt 0 ]; then
            echo "Invalid amount. Please insert a positive value."
        else
            total_payment=$((total_payment + payment))
            if [ $total_payment -gt $balance ]; then
                change=$((total_payment - balance))
                balance=0
                echo "Thank you for your purchase! Your change is $change CHF."
                sleep 2
            elif [ $total_payment -eq $balance ]; then
                balance=0
                echo "Thank you for your purchase!"
                sleep 2
            else
                remaining_balance=$((balance - total_payment))
                echo "Remaining balance: $remaining_balance CHF."
            fi
        fi
    done
    return 0  # Return 0 to indicate successful payment
}

# Function to add apple fans to the list
add_to_apple_fans() {
    read_non_empty "What's your name? "
    if test -e theList; then
        echo $input >> theList
    else
        touch theList
        echo $input >> theList
    fi

    echo "You have been added to the open source watchlist."
    echo "Say goodbye to your family and friends, you won't have long!"
    sleep 2
}

# Function to display order message
display_order_message() {
    if [ "$selected_milk" != "no-milk" ] || [ "$selected_sugar" != "no-sweetener" ]; then
        echo "Preparing a $beverage (with $selected_milk and $selected_sugar) for $original_price CHF."
    elif [ "$selected_sugar" == "" ]; then
         echo "Preparing a $beverage (with $selected_milk) for $original_price CHF."
    elif  [ "$selected_milk" == "" ]; then
        echo "Preparing a $beverage (with $selected_sugar) for $original_price CHF."
    else
        echo "Preparing $beverage for $original_price CHF."
    fi
}

# Function to simulate a loading bar
simulate_loading_bar() {
    #Loading bar stolen from the internet --> don't understand seq yet
    echo "Preparing..."
    for ((i=0; i<=100; i+=5)); do
        echo -ne "$i% ["
        printf "%0.s=" $(seq 1 $((i/2)))
        printf "%0.s " $(seq $(((100-i)/2)))
        echo -ne "]\r"
        sleep 0.1
    done
    # This is now again written by be without the help of the internet
    echo -e "\nFinished!"
    sleep 1
    echo "Please take your item from the dispenser"
    sleep 10
    echo ""
    clear
}

clear
start_machine
if [ $input -eq 1 ]; then
    running=1
fi
while [ $running -eq 1 ]; do
    get_beverage

    case $input in
        -1)
            echo "Displaying daily sales..."
            sleep 2
            echo "Daily Sales:"
            sleep 1
            for sale in "${daily_sales[@]}"; do
                echo "$sale"
                sleep 0.1
            done
            echo "System is shutting down, please wait..."
            simulate_loading_bar
            exit 0
            ;;
        1)
            select_cafe
            get_modifications
            daily_sales+=("$beverage: $original_price CHF")
            ;;
        2)
            select_tea
            get_modifications
            daily_sales+=("$beverage: $original_price CHF")
            ;;
        3)
            echo "You have chosen Sprite."
            beverage="Sprite"
            original_price=2
            daily_sales+=("Sprite: $original_price CHF")
            ;;
        4)
            echo "You have chosen Fanta."
            beverage="Fanta"
            original_price=2
            daily_sales+=("Fanta: $original_price CHF")
            ;;
        5)
            get_mineral_water
            if [ "$input" == 1 ]; then
                echo "You have chosen Mineral Water with gas."
                beverage="Mineral Water with gas"
                original_price=2
                daily_sales+=("Mineral Water with gas: $original_price CHF")
            elif [ "$input" == 2 ]; then
                echo "You have chosen Mineral Water without gas."
                beverage="Mineral Water without gas"
                original_price=1
                daily_sales+=("Mineral Water without gas: $original_price CHF")
            else
                echo "Invalid input"
                continue
            fi
            ;;
        6)
            get_cola
            case $input in
                1)
                    echo "You have chosen Normal Cola"
                    beverage="Normal Cola"
                    original_price=2
                    daily_sales+=("Normal Cola: $original_price CHF")
                    ;;
                2)
                    echo "You have chosen Light Cola"
                    beverage="Light Cola"
                    original_price=1
                    daily_sales+=("Light Cola: $original_price CHF")
                    ;;
                3)
                    echo "You have chosen Zero Cola"
                    beverage="Zero Cola"
                    original_price=1
                    daily_sales+=("Zero Cola: $original_price CHF")
                    ;;
                *)
                    echo "Invalid input"
                    continue
                    ;;
            esac
            ;;
        7)
            select_cigarettes
            daily_sales+=("$beverage: $original_price CHF")
            ;;
        *)
            echo "Invalid selection."
            continue
            ;;
    esac

    balance=$original_price

    if handle_payment; then
        echo "Are you an apple fan?"
        get_y_n
        if [ "$input" == "y" ]; then
            add_to_apple_fans
        else
            echo "Good."
        fi

        # Display order message
        display_order_message

        # Simulate loading bar
        simulate_loading_bar
    else
        echo "Transaction cancelled. Your balance was not updated."
    fi
done
