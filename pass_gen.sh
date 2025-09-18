#!/bin/bash

# Secure Password Generator in Bash
# Refactored from Python version

# Character sets
LOWERCASE="abcdefghijklmnopqrstuvwxyz"
UPPERCASE="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
DIGITS="0123456789"
SPECIAL="!@#\$%^&*()_+-=[]{}|;:,.<>?"

# Valid password lengths
VALID_LENGTHS=(12 16 20)

# File to track generated passwords (temporary)
GENERATED_FILE="/tmp/password_generator_$$"

# Function to check if length is valid
is_valid_length() {
    local length=$1
    for valid in "${VALID_LENGTHS[@]}"; do
        if [[ $length -eq $valid ]]; then
            return 0
        fi
    done
    return 1
}

# Function to get random character from string
get_random_char() {
    local charset=$1
    local length=${#charset}
    local index=$((RANDOM % length))
    echo "${charset:$index:1}"
}

# Function to shuffle a string
shuffle_string() {
    local input=$1
    local length=${#input}
    local result=""
    local remaining=$input
    
    while [[ ${#remaining} -gt 0 ]]; do
        local index=$((RANDOM % ${#remaining}))
        result="${result}${remaining:$index:1}"
        remaining="${remaining:0:$index}${remaining:$((index+1))}"
    done
    
    echo "$result"
}

# Function to check if password was already generated
is_password_unique() {
    local password=$1
    if [[ -f "$GENERATED_FILE" ]]; then
        grep -Fxq "$password" "$GENERATED_FILE"
        return $?
    fi
    return 1
}

# Function to add password to generated list
add_to_generated() {
    local password=$1
    echo "$password" >> "$GENERATED_FILE"
}

# Function to calculate approximate max combinations
calculate_max_combinations() {
    local length=$1
    local total_chars=$((${#LOWERCASE} + ${#UPPERCASE} + ${#DIGITS} + ${#SPECIAL}))
    # This is a simplified calculation - actual number is lower due to requirements
    echo $((total_chars ** length))
}

# Function to count generated passwords
count_generated() {
    if [[ -f "$GENERATED_FILE" ]]; then
        wc -l < "$GENERATED_FILE"
    else
        echo 0
    fi
}

# Function to clear generated passwords
clear_generated() {
    rm -f "$GENERATED_FILE"
    echo "All unique combinations used, starting new sequence"
}

# Main password generation function
generate_password() {
    local length=$1
    
    # Validate length
    if ! is_valid_length "$length"; then
        echo "Error: Length must be 12, 16, or 20" >&2
        return 1
    fi
    
    # Check if we need to reset the generated list
    local max_combinations=$(calculate_max_combinations "$length")
    local current_count=$(count_generated)
    
    if [[ $current_count -ge $max_combinations ]]; then
        clear_generated
    fi
    
    local password=""
    local attempts=0
    local max_attempts=1000
    
    while [[ $attempts -lt $max_attempts ]]; do
        # Ensure minimum requirements (1 of each type)
        local pwd=""
        pwd+=$(get_random_char "$LOWERCASE")  # 1 lowercase
        pwd+=$(get_random_char "$UPPERCASE")  # 1 uppercase  
        pwd+=$(get_random_char "$DIGITS")     # 1 digit
        pwd+=$(get_random_char "$SPECIAL")    # 1 special
        
        # Fill remaining length with random characters from all sets
        local all_chars="${LOWERCASE}${UPPERCASE}${DIGITS}${SPECIAL}"
        local remaining=$((length - 4))
        
        for ((i=0; i<remaining; i++)); do
            pwd+=$(get_random_char "$all_chars")
        done
        
        # Shuffle the entire password
        password=$(shuffle_string "$pwd")
        
        # Check if unique
        if ! is_password_unique "$password"; then
            add_to_generated "$password"
            echo "$password"
            return 0
        fi
        
        ((attempts++))
    done
    
    echo "Error: Could not generate unique password after $max_attempts attempts" >&2
    return 1
}

# Function to display menu
show_menu() {
    echo ""
    echo "Secure Password Generator"
    echo "Available lengths: 12, 16, 20"
    echo -n "Enter password length (or 0 to quit): "
}

# Main function
main() {
    # Set up better random seed
    RANDOM=$$$(date +%s)
    
    # Trap to cleanup on exit
    trap 'rm -f "$GENERATED_FILE"' EXIT
    
    echo "Bash Password Generator"
    echo "======================"
    
    while true; do
        show_menu
        read -r length
        
        # Check if user wants to quit
        if [[ "$length" == "0" ]]; then
            echo "Goodbye!"
            break
        fi
        
        # Validate input is a number
        if ! [[ "$length" =~ ^[0-9]+$ ]]; then
            echo "Error: Please enter a valid number"
            continue
        fi
        
        # Generate password
        echo -n "Generated Password: "
        if ! generate_password "$length"; then
            echo "Failed to generate password"
        fi
    done
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
