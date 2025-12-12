#!/bin/bash

TARGET_DIR="deployment_dir"
ZIP_FILE="deployment_dir.zip"

echo "Starting script"

# Check if dir exist, if not, unzip the file
if [ ! -d "$TARGET_DIR" ]; then
	if [ -f "$ZIP_FILE" ]; then
		echo "Directory '$TARGET_DIR' not found, but '$ZIP_FILE' detected."
		echo "Unzipping"

		unzip -q "$ZIP_FILE" -d "$TARGET_DIR"
	else
		echo "ERROR: Cannot find '$TARGET_DIR' directory or '$ZIP_FILE'."
		exit 1
	fi
fi


function audit_file_type() {
	echo "Counting file types..."

	#1. Find and search all files
	#2. Use sed to replace everything up to the last dot with nothing (maintain file extension)
	#3. Sort and uniq -c occurences

	echo "File types summary:" > task1Output.txt

	find "$TARGET_DIR" -type f | sed -n 's/.*\.\(.*\)/\1/p' | sort | uniq -c | awk '{print $2, "Count:", $1}' >> task1Output.txt

	cat task1Output.txt
	echo "Task 1 complete. Saved to task1Output.txt"
}

function audit_sus_files() {
	echo "Scanning for suspicious files..." > task2Output.txt 

	# Find files where names contain debug/test/temp OR extensions such as .bak/.old/.tmp
	# Print warnings

	find "$TARGET_DIR" -type f \( -name "*debug*" -o -name "*test*" -o -name "*.bak" -o -name "*.old" -o -name "*.tmp" \) -print0 |
		while IFS= read -r -d '' file; do
			echo "Suspicious file detected: $file" >> task2Output.txt
		done

		cat task2Output.txt
	}

	function audit_danger_commands() {
		echo "Scanning .sh files for dangerous commands (rm -rf, scp, curl, sudo...)" > task3Output.txt

		# array list of dangerous commands
		commands=("rm -rf" "scp" "curl" "sudo")

		# find .sh files
		find "$TARGET_DIR" -name "*.sh" -print0 | while IFS= read -r -d '' script_file; do
		for cmd in "${commands[@]}"; do
			# silent grep for command strings
			if grep -q "$cmd" "$script_file"; then
				echo "${script_file}: uses dangerous command '$cmd'" >> task3Output.txt
			fi
		done
	done
}

function audit_logs() {
	echo "Scanning logs" > task4Output.txt

	ACCESS_LOG="$TARGET_DIR/logs/access.log"
	ERROR_LOG="$TARGET_DIR/logs/error.log"

	if [ -f  "$ACCESS_LOG" ]; then
		echo "Log analysis:" >> task4Output.txt

		# 1. Unique IP counts
		unique_ips=$(awk '{print $1}' "$ACCESS_LOG" | sort | uniq | wc -l)
		echo "Unique IP hits: $unique_ips" >> task4Output.txt

		# 2. Top 3 visited pages
		awk '{print $7}' "$ACCESS_LOG" | sort | uniq -c | sort -nr | head -3 >> task4Output.txt
	else
		echo "Warning: error.log not found" >> task4Output.txt
	fi

	if [ -f "$ERROR_LOG" ]; then
		grep "File does not exist" "$ERROR_LOG" >> task4Output.txt
	else
		echo "Warning: error.log not found" >> task4Output.txt
	fi

	cat task4Output.txt
}

function audit_secrets() {
	echo "Scanning for secret" > task5Output.txt

	# Check for extensions: .env/.conf/.json/.pem
	# Keywords: SECRET,PASSWORD,KEY,PRIVATE

	grep -rE -n "SECRET|PASSWORD|KEY|PRIVATE" \
		--include="*.env" --include="*.conf" --include="*.json" --include="*.pem" \
		"$TARGET_DIR" >> task5Output.txt

	cat task5Output.txt
}

# MAIN MENU

function show_menu() {
	echo "1. Audit file types"
	echo "2. Check for suspicious files"
	echo "3. Check for dangerous commands (.sh)"
	echo "4. Analyze logs"
	echo "5. Scan for secrets"
	echo "Type 'end' to exit program"
}

# Exec loop

while true; do
	show_menu
	read -p "Select option: " choice

	case $choice in
		1) audit_file_type ;;
		2) audit_sus_files ;;
		3) audit_danger_commands ;;
		4) audit_logs ;;
		5) audit_secrets ;;
		"end")
			echo "Exiting program"
			break
			;;
		*)
			echo "Invalid option. Please try again"
			;;
	esac

	echo ""
	read -p "Press enter to continue"
done
