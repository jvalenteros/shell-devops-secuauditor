# Deployment Audit Script

![Language](https://img.shields.io/badge/language-Bash-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

This is a bash project script for my **File Systems - Linux** course. It provides a set of tools to audit a deployment directory for security vulnerabilities, suspicious files, and other issues.

## Features

*   **File Type Audit:** Counts the number of files of each type (e.g., `.sh`, `.conf`, `.js`) in the deployment directory.
*   **Suspicious File Scan:** Identifies files with potentially sensitive names, such as those containing "debug," "test," or "temp," and extensions like `.bak`, `.old`, or `.tmp`.
*   **Dangerous Command Detection:** Scans all `.sh` files for potentially harmful commands, including `rm -rf`, `scp`, `curl`, and `sudo`.
*   **Log Analysis:** Analyzes `access.log` and `error.log` files to extract key metrics, such as the number of unique IP addresses, the top 3 most visited pages, and any "File does not exist" errors.
*   **Hardcoded Secrets Detection:** Searches configuration files (e.g., `.env`, `.conf`, `.json`, `.pem`) for hardcoded secrets, passwords, keys, or other sensitive credentials.

## Prerequisites

*   A Bash-compatible shell (e.g., Git Bash on Windows, or any standard Linux/macOS terminal).
*   The `unzip` command-line tool.
*   A `deployment_dir.zip` file in the same directory as the script, containing the deployment files to be audited.

## How to Use

1.  **Place the script and the `deployment_dir.zip` file in the same directory.**

2.  **Make the script executable:**
    ```bash
    chmod +x deploymentAudit.sh
    ```

3.  **Run the script:**
    ```bash
    ./deploymentAudit.sh
    ```

4.  **Follow the on-screen menu to select an audit task.** The script will guide you through the available options.

    - **Option 1: Audit file types** - Counts and displays the number of files for each file extension.
    - **Option 2: Check for suspicious files** - Lists any files with suspicious names or extensions.
    - **Option 3: Check for dangerous commands (.sh)** - Reports any `.sh` files containing potentially dangerous commands.
    - **Option 4: Analyze logs** - Provides an analysis of `access.log` and `error.log`.
    - **Option 5: Scan for secrets** - Searches for and displays any hardcoded credentials found in configuration files.

5.  **View the output.** The results of each task are saved to a corresponding output file (e.g., `task1Output.txt`, `task2Output.txt`, etc.).

To exit the script,  type `end` at the menu prompt.
