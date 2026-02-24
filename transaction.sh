#!/bin/bash

# ============================================================
#   ATM Management System - Debit & Credit Transaction Process
#   Script   : Transaction.sh
#   Institute: Tamilnadu Advanced Technical Training Institute
# ============================================================

# Safety check: ensure script runs with bash, not sh/dash
if [ -z "$BASH_VERSION" ]; then
    echo "ERROR: This script must be run with bash."
    echo "Usage: bash Transaction.sh"
    exit 1
fi

# ──────────────────────────────────────────────
# Global Variables
# ──────────────────────────────────────────────
CUSTOMER_NAME=""
ID_TYPE=""
ID_VALUE=""
ACCOUNT_TYPE=""
BALANCE=0
ATM_PIN="12345"

# ============================================================
# FUNCTION 1: Customer_Details — Account Creation
# ============================================================
Customer_Details() {
    while true; do
        echo ""
        echo "Account Creation Process Started..."

        # Get Customer Full Name
        read -p "Enter the FullName in Bold Letters:" input_name
        CUSTOMER_NAME=$(echo "$input_name" | tr '[:lower:]' '[:upper:]')

        if [[ -z "$CUSTOMER_NAME" ]]; then
            echo "Name cannot be empty."
            echo "Account Creation Process Failed. Restarting Again....."
            echo "------------------------------------------------"
            continue
        fi

        # Get ID Proof Type
        read -p "Enter the ID Proof Type [Ex: Aadhar, Pan, License, etc..]: " ID_TYPE
        ID_TYPE_UPPER=$(echo "$ID_TYPE" | tr '[:lower:]' '[:upper:]')

        case "$ID_TYPE_UPPER" in

            AADHAR)
                read -p "Enter Aadhar Number:" ID_VALUE
                if [[ ! "$ID_VALUE" =~ ^[0-9]+$ ]]; then
                    echo "Only Numbers are Allowed"
                    echo "Account Creation Process Failed. Restarting Again....."
                    echo "------------------------------------------------"
                    continue
                fi
                ;;

            PAN)
                read -p "Enter Pan Card Details [Note: Without Special Characters and Spaces:" ID_VALUE
                if [[ ! "$ID_VALUE" =~ ^[a-zA-Z0-9]+$ ]]; then
                    echo "Only Letters & Numbers are Allowed"
                    echo "Account Creation Process Failed. Restarting Again....."
                    echo "------------------------------------------------"
                    continue
                fi
                ;;

            LICENSE)
                read -p "Enter the License Number:" ID_VALUE
                if [[ ! "$ID_VALUE" =~ ^[0-9]+$ ]]; then
                    echo "Only Numbers are Allowed"
                    echo "Account Creation Process Failed. Restarting Again....."
                    echo "------------------------------------------------"
                    continue
                fi
                ;;

            *)
                echo "InValid ID Proof Type."
                echo "Account Creation Process Failed. Restarting Again....."
                echo "------------------------------------------------"
                continue
                ;;
        esac

        # Get Account Type
        read -p "Enter the Account Type as Savings or Current:" ACCOUNT_TYPE
        ACCOUNT_TYPE_UPPER=$(echo "$ACCOUNT_TYPE" | tr '[:lower:]' '[:upper:]')
        if [[ "$ACCOUNT_TYPE_UPPER" != "SAVINGS" && "$ACCOUNT_TYPE_UPPER" != "CURRENT" ]]; then
            echo "InValid Account Type"
            echo "Account Creation Process Failed. Restarting Again......"
            echo "------------------------------------------------"
            continue
        fi
        ACCOUNT_TYPE="$ACCOUNT_TYPE_UPPER"

        # Get Initial Deposit Amount
        read -p "Enter the Deposit Amount: Rs." DEPOSIT_AMOUNT
        if [[ ! "$DEPOSIT_AMOUNT" =~ ^[0-9]+$ ]]; then
            echo "InValid Deposit Amount. [Note: Numbers only Allowed."
            echo "Account Creation Process Failed. Restarting Again......"
            echo "------------------------------------------------"
            continue
        fi

        BALANCE=$DEPOSIT_AMOUNT

        echo ""
        echo "Account Created Successfuly with Initial Deposit"
        echo "Your Current Available Balance is Rs.$BALANCE"

        Customer_Choice
        break
    done
}

# ============================================================
# FUNCTION 2: Customer_Choice — ATM Card Processing
# ============================================================
Customer_Choice() {
    while true; do
        read -p "Do you want to Apply for ATM Card: Type Yes or No " CARD_CHOICE
        CARD_CHOICE_UPPER=$(echo "$CARD_CHOICE" | tr '[:lower:]' '[:upper:]')

        case "$CARD_CHOICE_UPPER" in

            YES)
                echo "Your ATM Card is Processed"
                echo "Your Temporary ATM Pin Number is: $ATM_PIN"

                while true; do
                    read -p "Do you want Access ATM?: Type Okay or Cancel " ACCESS_CHOICE
                    ACCESS_CHOICE_UPPER=$(echo "$ACCESS_CHOICE" | tr '[:lower:]' '[:upper:]')

                    if [[ "$ACCESS_CHOICE_UPPER" == "OKAY" ]]; then
                        ATM_Process
                        return
                    elif [[ "$ACCESS_CHOICE_UPPER" == "CANCEL" ]]; then
                        echo "Thankyou Visit Again !!"
                        exit 0
                    else
                        echo "Invalid Choice. Please type Okay or Cancel."
                    fi
                done
                ;;

            NO)
                echo "Thanks for Being a Valuable Customer to Us"
                exit 0
                ;;

            *)
                echo "ATM Card Process Failed. Restarting the Card Process Again......"
                echo "------------------------------------------------"
                continue
                ;;
        esac
    done
}

# ============================================================
# FUNCTION 3: ATM_Process — Transaction Selection
# ============================================================
ATM_Process() {
    while true; do

        # PIN Verification
        while true; do
            read -p "Enter the Pin Number: " ENTERED_PIN
            if [[ "$ENTERED_PIN" == "$ATM_PIN" ]]; then
                echo "Welcome User!!"
                break
            else
                echo "Invalid Pin Number"
            fi
        done

        # Transaction Choice
        while true; do
            read -p "Enter 1 For Cash Withdraw or 2 For Cash Deposit " TXN_CHOICE

            if [[ "$TXN_CHOICE" == "1" ]]; then
                Debit_Process
                break
            elif [[ "$TXN_CHOICE" == "2" ]]; then
                Credit_Process
                break
            else
                echo "You Have Entered Wrong Choice. Restarting the Process Again......"
                echo "------------------------------------------------"
                break
            fi
        done

        # Another Transaction?
        read -p "Do you want to perform another transaction? Type Yes or No: " ANOTHER
        ANOTHER_UPPER=$(echo "$ANOTHER" | tr '[:lower:]' '[:upper:]')
        if [[ "$ANOTHER_UPPER" != "YES" ]]; then
            echo "Thankyou Visit Again !!"
            exit 0
        fi

    done
}

# ============================================================
# FUNCTION 4: Debit_Process — Cash Withdraw
# ============================================================
Debit_Process() {
    while true; do
        read -p "Enter the Amount to Withdraw: Rs." WITHDRAW_AMOUNT

        # Validate: Numbers only
        if [[ ! "$WITHDRAW_AMOUNT" =~ ^[0-9]+$ ]]; then
            echo "InValid Amount. Numbers Only Allowed."
            continue
        fi

        # Validate: Must be multiple of 100 (ATM denomination rule)
        if (( WITHDRAW_AMOUNT % 100 != 0 )); then
            echo "Enter The Valid Amount"
            continue
        fi

        # Validate: Sufficient balance
        if (( WITHDRAW_AMOUNT > BALANCE )); then
            echo "Insufficient Balance"
            echo "Your Current Available is Rs.$BALANCE"
            continue
        fi

        # Process Withdrawal
        (( BALANCE -= WITHDRAW_AMOUNT ))
        echo "Your Current Available Balance After Deduction is Rs.$BALANCE"
        break
    done
}

# ============================================================
# FUNCTION 5: Credit_Process — Cash Deposit
# ============================================================
Credit_Process() {
    while true; do
        read -p "Enter the Amount to Deposit Rs." DEPOSIT_AMOUNT

        # Validate: Numbers only
        if [[ ! "$DEPOSIT_AMOUNT" =~ ^[0-9]+$ ]]; then
            echo "InValid Amount. Numbers Only Allowed."
            continue
        fi

        # Validate: Must be multiple of 500 (ATM denomination rule)
        if (( DEPOSIT_AMOUNT % 500 != 0 )); then
            echo "Enter The Valid Amount"
            continue
        fi

        # Process Deposit
        (( BALANCE += DEPOSIT_AMOUNT ))
        echo "Your Amount Deposited Successfully !!"
        echo "Your Current Available Balance is Rs.$BALANCE"
        break
    done
}

# ============================================================
# MAIN — Program Entry Point
# ============================================================
Customer_Details