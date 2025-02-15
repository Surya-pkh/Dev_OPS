#I have deployed an application in guvi.com:9000, and logs show my app is running, but I’m unable to view the page. Check whether my port is open or not ?

sudo ss -tunl

#The command sudo ss -tuln is used to display listening network sockets on a Linux system. Here's a breakdown of the options used:

ss → A utility to investigate sockets (similar to netstat, but faster and more powerful).

-t → Show TCP sockets.

-u → Show UDP sockets.

-l → Show only listening sockets (services waiting for connections).

-n → Show numerical addresses instead of resolving hostnames.
