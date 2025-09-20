![Python](https://img.shields.io/badge/python-3.6+-blue.svg)
![License](https://img.shields.io/badge/license-GPL%20v3.0-blue.svg)
![Security](https://img.shields.io/badge/security-cryptographically%20secure-red.svg)
![Dependencies](https://img.shields.io/badge/dependencies-none-brightgreen.svg)
![Lengths](https://img.shields.io/badge/lengths-12%20%7C%2016%20%7C%2020-blue.svg)
![Status](https://img.shields.io/badge/status-stable-brightgreen.svg)

# GeNieNigMa
A Python secure password generator that creates unique passwords of length 12, 16, or 20, always including lowercase, uppercase, digits, and special characters, with non-repeating sequences until all combinations are exhausted.

# GeNieNigMa

A secure password generator built in Python that creates cryptographically strong passwords with guaranteed character diversity.

## Features

- **Cryptographically Secure**: Uses Python's `secrets` module for true randomness
- **Character Diversity**: Every password contains at least one lowercase, uppercase, digit, and special character
- **Multiple Lengths**: Supports 12, 16, and 20 character passwords
- **Duplicate Prevention**: Tracks generated passwords to avoid repeats
- **Simple CLI Interface**: Easy-to-use command line interface

## Installation

1. Clone this repository:
```bash
git clone <your-repo-url>
cd genienigma
```

2. No additional dependencies required - uses only Python standard library

## Usage

Run the password generator:

```bash
python genienigma.py
```

Follow the prompts to select your desired password length (12, 16, or 20 characters).

### Example Output

```
Secure Password Generator
Available lengths: 12, 16, 20
Enter password length (or 0 to quit): 16
Generated Password: K7$mP9qX&nE2vL4z
```

## Character Sets

- **Lowercase**: a-z (26 characters)
- **Uppercase**: A-Z (26 characters) 
- **Digits**: 0-9 (10 characters)
- **Special**: !@#$%^&*()_+-=[]{}|;:,.<>? (23 characters)

Total character pool: 85 characters

## Security Features

### Cryptographic Randomness
Uses `secrets.choice()` and `secrets.SystemRandom().shuffle()` for cryptographically secure random number generation, suitable for security-sensitive applications.

### Guaranteed Complexity
Each password is guaranteed to contain:
- At least 1 lowercase letter
- At least 1 uppercase letter
- At least 1 digit
- At least 1 special character

### Duplicate Prevention
The generator tracks all previously generated passwords and ensures no duplicates are returned until all possible combinations are exhausted.

## Code Structure

### PasswordGenerator Class

- `__init__()`: Initializes character sets and tracking
- `generate_password(length)`: Creates a new unique password
- `calculate_max_combinations(length)`: Estimates total possible passwords

### Main Function
Provides the command-line interface for user interaction.

## Technical Details

**Password Generation Algorithm:**
1. Select one character from each required category
2. Fill remaining positions with random characters from all sets
3. Shuffle the entire password to randomize positions
4. Check uniqueness against previously generated passwords
5. Return the password if unique, otherwise retry

**Supported Lengths:** 12, 16, 20 characters
**Platform:** Cross-platform (Windows, macOS, Linux)
**Python Version:** 3.6+

## Security Considerations

- Uses cryptographically secure random number generation
- No password storage or logging
- Passwords are only displayed once and not saved
- Memory is cleared when the program exits

## Contributing

Feel free to submit issues and enhancement requests. Pull requests are welcome.

## License
GNU General Public License v3.0


## Disclaimer
This tool generates passwords for legitimate security purposes. Users are responsible for following their organization's password policies and security guidelines.
