# 🔐 jks2json

A sleek, interactive Bash script that automatically detects Android Keystore (`.jks`) files, securely verifies your password, and extracts all vital signing credentials into a clean, organized JSON file. 

Built by **MaheshTechnicals**.

## 🤔 Why use this?
Setting up CI/CD pipelines (like GitHub Actions) or backing up Android build credentials can be a hassle. This tool automates the extraction of:
* Keystore Alias
* Keystore & Key Passwords
* SHA-1 and SHA-256 Fingerprints
* The full Keystore Base64 Encoded String (Required for cloud signing)

## ✨ Features
- **Auto-Discovery:** Automatically scans your current directory for all `.jks` files and presents them in a numbered menu.
- **Secure Input:** Password input is masked and verified before extraction begins.
- **Beautiful UI:** Features truecolor ANSI gradient styling in the terminal.
- **Smart Organization:** Automatically creates a `json/` directory and names the output file perfectly.

## 🚀 Installation

Clone the repository to your local machine, Termux, or Linux server:

```bash
git clone https://github.com/MaheshTechnicals/jks2json.git
cd jks2json
chmod +x jks2json.sh
```

## 📖 Usage

Place your `.jks` file(s) into the same directory as the script, then simply run:

```bash
./jks2json.sh
```

1. Select your keystore from the generated list.
2. Enter your keystore password.
3. Check the `json/` folder for your extracted credentials!

## ⚠️ Security Warning
The generated `.json` files contain **highly sensitive plain-text passwords and your private keys**. 
* **NEVER** commit the `json/` folder or any generated `.json` files to GitHub. 
* Add `json/` to your `.gitignore` file immediately.
* Store the generated JSON files in a secure, encrypted vault.

---
*Made with ❤️ for the Android Development Community.*