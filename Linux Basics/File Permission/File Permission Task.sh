# switching to root to acquired the path /home
  sudo -s
  cd ..
  
# Create a file with .txt extension (/home/demo.txt).
  touch demo.txt
  ls -l
  
# Change the permission set of that file, so that any user can read it, group can read/write & owner can read/write/execute it.
  chmod 764 demo.txt
# Explanation of chmod 764:
# 7 (Owner) → Read (4) + Write (2) + Execute (1) = rwx
# 6 (Group) → Read (4) + Write (2) = rw-
# 4 (Others) → Read (4) = r--

# list the files in current directory
  ls -l
  
