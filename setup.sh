#!/usr/bin/env bash

set -e

echo "Welcome to the Python Project Template Bootstrap Script!"
echo "Please provide the following information to set up your project:"

read -p "Project name (e.g., my-awesome-project) [Enter for default: python-template]: " project_name
project_name=${project_name:-python-template}

read -p "Author name (e.g., Jane Doe) [Enter for default: Noé Fontana]: " author_name
author_name=${author_name:-Noé Fontana}

read -p "Author email (e.g., jane@example.com) [Enter for default: noe.fontana.pro@gmail.com]: " author_email
author_email=${author_email:-noe.fontana.pro@gmail.com}

read -p "GitHub username (e.g., janedoe) [Enter for default: NoeFontana]: " github_username
github_username=${github_username:-NoeFontana}

project_package_name=$(echo "$project_name" | tr '-' '_')

echo ""
echo "Setting up project: $project_name"
echo "Package name: $project_package_name"
echo "Author: $author_name <$author_email>"
echo "GitHub: $github_username"
echo ""

# Rename the source directory
if [ -d "src/python_template" ] && [ "$project_package_name" != "python_template" ]; then
    echo "Renaming src/python_template to src/$project_package_name..."
    mv src/python_template "src/$project_package_name"
fi

echo "Updating project files..."

# Function to safely replace strings across files
replace_string() {
    local search=$1
    local replace=$2
    # Find files and perform replacement. Excluding .git directory, setup.sh, and binary/lock files.
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS sed
        find . -type f -not -path "*/\.git/*" -not -name "setup.sh" -not -name "uv.lock" -not -path "*/__pycache__/*" -exec grep -l "$search" {} \; | while read -r file; do
            sed -i '' "s|${search}|${replace}|g" "$file"
        done
    else
        # GNU sed
        find . -type f -not -path "*/\.git/*" -not -name "setup.sh" -not -name "uv.lock" -not -path "*/__pycache__/*" -exec grep -l "$search" {} \; | while read -r file; do
            sed -i "s|${search}|${replace}|g" "$file"
        done
    fi
}

# 1. Replace NoeFontana -> github_username
if [ "$github_username" != "NoeFontana" ]; then
    replace_string "NoeFontana" "$github_username"
fi

# 2. Replace Noé Fontana -> author_name
if [ "$author_name" != "Noé Fontana" ]; then
    replace_string "Noé Fontana" "$author_name"
fi

# 3. Replace noe.fontana.pro@gmail.com -> author_email
if [ "$author_email" != "noe.fontana.pro@gmail.com" ]; then
    replace_string "noe.fontana.pro@gmail.com" "$author_email"
fi

# 4. Replace python_template -> project_package_name
if [ "$project_package_name" != "python_template" ]; then
    replace_string "python_template" "$project_package_name"
fi

# 5. Replace python-template -> project_name
if [ "$project_name" != "python-template" ]; then
    replace_string "python-template" "$project_name"
fi

echo "Syncing dependencies with uv..."
if command -v uv &> /dev/null; then
    uv sync
else
    echo "Warning: uv not found. Please run 'uv sync' manually after installing uv."
fi

echo "Cleaning up..."
# Remove this script
rm -- "$0"

echo "Creating initial commit..."
if [ -d ".git" ]; then
    git add .
    git commit -m "chore: initial project setup from template"
    echo "Setup complete! You can now push your repository."
else
    echo "Warning: .git directory not found. Skipping git commit."
fi
