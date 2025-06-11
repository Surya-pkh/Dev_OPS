import os
import datetime
import subprocess

# === CONFIGURE THESE VARIABLES ===
REPO_PATH = "/path/to/your/local/repo"  # Change this to your repo path
COMMIT_FILE = "daily_commit_log.txt"    # File to update daily
COMMIT_MESSAGE = "Automated daily commit"

def update_file(file_path):
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(file_path, "a") as f:
        f.write(f"Committed on {now}\n")

def git_commit_push(repo_path, commit_message):
    try:
        subprocess.run(["git", "add", "."], cwd=repo_path, check=True)
        subprocess.run(["git", "commit", "-m", commit_message], cwd=repo_path, check=True)
        subprocess.run(["git", "push"], cwd=repo_path, check=True)
        print("Commit and push successful.")
    except subprocess.CalledProcessError as e:
        print("Error during git operations:", e)

if __name__ == "__main__":
    full_path = os.path.join(REPO_PATH, COMMIT_FILE)
    update_file(full_path)
    git_commit_push(REPO_PATH, COMMIT_MESSAGE)
