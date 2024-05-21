#!/bin/bash

#-------------------------------------------------
# Author:               Luca Fabian Burger
# Organisation          IMS
# Version:              1.5
# Task:                 Beverage Vending Machine
# OS:                   Linux (arch) native
# Date:                 14.5.24
# Last added feature:   Daily_sailes fixes
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

# Function to start the machine
start_machine(){
    clear
    is_machine_active=0
    while [ $is_machine_active -ne 1 ]; do
        echo "Press 1 to start the machine"
        read input
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
    read -p "What would you like? (-1 to Cancel): " input
}

# Function to get cafe input
get_cafe() {
    echo "Cafe Menu:"
    echo "1) Espresso"
    echo "2) Latte Machiato"
    echo "3) Coffee"
    read -p "What kind of cafe would you like? " input
}

# Function to get tea input
get_tea() {
    echo "Tea Menu:"
    echo "1) Schwarztee"
    echo "2) Grüntee"
    echo "3) Jasmintee"
    echo "4) Vanille Tee"
    read -p "What kind of tea would you like? " input
}

# Function to get cigarette input
get_cigarettes() {
    echo "Cigarette Menu:"
    echo "1) Chetserfield"
    echo "2) Malboro"
    echo "3) Camel"
    echo "4) Winston"
    echo "5) Lucky Strike"
    read -p "What brand of cigarettes would you like? " input
}

# Function to get mineral water input
get_mineral_water() {
    echo "Mineral Water Menu:"
    echo "1) With gas"
    echo "2) Without gas"
    read -p "Do you want mineral water with or without gas? " input
}

# Function to get cola input
get_cola() {
    echo "Cola Menu:"
    echo "1) Normal"
    echo "2) Light"
    echo "3) Zero"
    read -p "What kind of cola would you like? " input
}

# Function to get yes or no input
get_y_n(){
    read -p "Yes or no? (y/n) " input
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
        read -p "What kind of milk would you like? " input
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
        read -p "What kind of sweetener would you like? " input
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
        read -p "Initial price $balance CHF. Please insert coins or bills (Enter -1 to cancel): " payment
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
    read -p "Whats your name? " input
    if test -e theList
    then
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
    elif [ "$selected_s
