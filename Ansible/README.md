# Ansible Deployment Project

## 📋 Overview
This project demonstrates how to automate the setup of a web and database server infrastructure using **Ansible**. It includes:

- MySQL installation and configuration on a database server
- Apache installation and website deployment on an application server
- SSH connectivity, inventory setup, and troubleshooting steps

## 🗂️ Project Structure

```

.
├── inventory.ini              # Ansible inventory file with grouped hosts
├── install\_mysql.yml          # Playbook to install and secure MySQL
├── deploy\_webapp.yml          # Playbook to deploy Apache and website
├── Ansible\_Deployment\_Documentation.docx  # Full step-by-step documentation
└── README.md                  # Project description and usage

````

## 🌐 Hosts Configuration
Edit `inventory.ini` with your instance IPs and SSH key path:
```ini
[db_servers]
10.128.0.10 ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/gcp-key ansible_python_interpreter=/usr/bin/python3

[app_servers]
10.128.0.9 ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/gcp-key ansible_python_interpreter=/usr/bin/python3

[all_nodes:children]
db_servers
app_servers
````

## 🔐 SSH Setup

Ensure passwordless SSH access to all nodes:

```bash
ssh-copy-id -i ~/.ssh/gcp-key ubuntu@10.128.0.9
ssh-copy-id -i ~/.ssh/gcp-key ubuntu@10.128.0.10
```

Test connectivity:

```bash
ansible all_nodes -m ping -i inventory.ini
```

## 📦 MySQL Installation

Run the database setup playbook:

```bash
ansible-playbook -i inventory.ini install_mysql.yml
```

## 🌍 Apache & Web Deployment

Deploy the web server and site:

```bash
ansible-playbook -i inventory.ini deploy_webapp.yml
```

Verify the deployment:

```bash
curl http://<app_server_ip>
```

## ❗ Troubleshooting

| Issue                    | Solution                                     |
| ------------------------ | -------------------------------------------- |
| SSH timeout              | Check firewall (e.g. `sudo ufw allow 22`)    |
| MySQL root access denied | Re-run the MySQL secure installation task    |
| Website not loading      | Check `/var/www` permissions & Apache config |

Useful debug commands:

```bash
ansible app_servers -a "systemctl status apache2" --become
ansible app_servers -a "tail -n 20 /var/log/apache2/error.log" --become
```

## ✅ Next Steps

* Automate database backups using `mysqldump + cron`
* Add monitoring (Prometheus + Grafana)
* Enable HTTPS with Let's Encrypt

---

## 📄 Documentation

You can find the full step-by-step deployment guide in [`Ansible_Deployment_Documentation.docx`](./Ansible_Deployment_Documentation.docx)

---

## 🧑‍💻 Author

**Surya Prakash**
DevOps & Cloud Enthusiast 🚀

---

## 📜 License

This project is open-source and free to use.

```

---

Let me know if you want it saved as a file (`README.md`) so you can directly upload it to GitHub.
```
