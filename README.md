Barry Red Team Toolbox

A portable Red Team environment built from a single repository.

Each deployment method installs Kali and then runs:

./install/setup.sh

This installs and configures the toolbox automatically.

Section A — Bare Metal Install (Dedicated Machine)

This installs Kali directly onto a computer’s internal disk.

Use this if you want a permanent Red Team workstation.

Step 1 — Download the Kali Installer
What this step achieves

Downloads the operating system installer.

What to do

Download the Installer ISO from the official Kali website.

Example filename:

kali-linux-2026.x-installer-amd64.iso

Important: choose the Installer image, not the Live version.

Reason:

Image Type	Purpose
Installer	full operating system install
Live	temporary environment
Step 2 — Create a bootable installer USB
What this step achieves

Creates a USB drive that can start the installer.

Tools commonly used:

Balena Etcher

Rufus

What to do

Insert an empty USB drive (8GB or larger).

Open the flashing tool.

Select the Kali ISO.

Select the USB drive.

Click Flash.

Wait until flashing completes.

Step 3 — Boot the computer from the USB
What this step achieves

Starts the Kali installer.

What to do

Restart the computer and open the boot menu.

Common keys:

Manufacturer	Boot Key
Dell	F12
HP	F9
Lenovo	F12
ASUS	ESC

Select the USB drive.

Step 4 — Install Kali Linux
What this step achieves

Installs Kali onto the computer.

What to do

In the menu select:

Graphical Install

Follow the prompts:

Select language

Select keyboard

Set hostname

Create username

Create password

When prompted for disk partitioning choose:

Guided – use entire disk

Allow installation to complete.

Restart when prompted.

Step 5 — Log into Kali
What this step achieves

Access the installed operating system.

What to do

Log in using the username and password created during installation.

Step 6 — Update Kali
What this step achieves

Ensures the system is fully up to date.

What to type
sudo apt update
sudo apt upgrade -y
Step 7 — Install Git
What this step achieves

Allows downloading the toolbox repository.

What to type
sudo apt install git -y
Step 8 — Clone the toolbox repository
What this step achieves

Downloads the Barry Red Team Toolbox.

What to type

Replace <username> with your GitHub username.

git clone https://github.com/<username>/barry-red-team-toolbox

Move into the folder:

cd barry-red-team-toolbox
Step 9 — Run the toolbox installer
What this step achieves

Installs and configures the Red Team tools.

What to type
chmod +x install/setup.sh
./install/setup.sh

Your Red Team toolbox is now installed.

Section B — Bootable External Drive (Portable System)

This installs Kali onto an external drive so it can run on any compatible computer.

Step 1 — Download Kali Installer

Download the Installer ISO.

Example:

kali-linux-2026.x-installer-amd64.iso
Step 2 — Create installer USB

Use a flashing tool such as:

Balena Etcher

Rufus

Flash the ISO to a USB drive.

Step 3 — Boot the target computer

Restart the computer and open the boot menu.

Select the installer USB.

Step 4 — Install Kali to the external drive

During disk selection:

Choose the external drive.

Be careful to avoid selecting the host computer’s internal disk.

Continue installation.

Restart after installation completes.

Step 5 — Boot from the external drive

Restart the computer.

Select the external drive in the boot menu.

Kali will now run from the external device.

Step 6 — Update Kali
sudo apt update
sudo apt upgrade -y
Step 7 — Install Git
sudo apt install git -y
Step 8 — Clone toolbox
git clone https://github.com/<username>/barry-red-team-toolbox
cd barry-red-team-toolbox
Step 9 — Run installer
chmod +x install/setup.sh
./install/setup.sh

The portable toolbox is ready.

Section C — VMware Virtual Machine

This runs Kali inside a virtual machine.

Hypervisors:

VMware Workstation

VMware Player

Step 1 — Install VMware

Download and install VMware Workstation or Player.

Follow the installer prompts.

Step 2 — Download Kali ISO

Download the Installer ISO.

Step 3 — Create a new VM

Open VMware and choose:

Create New Virtual Machine

Select:

Installer Disk Image

Choose the Kali ISO.

Step 4 — Configure VM resources

Recommended settings:

Resource	Value
RAM	4GB
CPU	2 cores
Disk	40GB
Step 5 — Install Kali in the VM

Run the Graphical Install option and complete installation.

Step 6 — Update Kali
sudo apt update
sudo apt upgrade -y
Step 7 — Install Git
sudo apt install git -y
Step 8 — Clone repository
git clone https://github.com/<username>/barry-red-team-toolbox
cd barry-red-team-toolbox
Step 9 — Run installer
chmod +x install/setup.sh
./install/setup.sh

The VM now contains the toolbox.

Section D — Container Deployment

This runs the toolbox inside a container.

Container runtime:

Docker

Step 1 — Install Docker
sudo apt update
sudo apt install docker.io -y

Start Docker:

sudo systemctl start docker
sudo systemctl enable docker
Step 2 — Create Dockerfile

Create file:

container/Dockerfile

Example:

FROM kalilinux/kali-rolling

RUN apt update && apt install -y git

WORKDIR /root

RUN git clone https://github.com/<username>/barry-red-team-toolbox

WORKDIR /root/barry-red-team-toolbox

RUN chmod +x install/setup.sh && ./install/setup.sh
Step 3 — Build container
docker build -t barry-red-team-toolbox ./container
Step 4 — Run container
docker run -it barry-red-team-toolbox

The container will launch with the toolbox installed.

Summary

Each deployment method follows the same concept:

Install Kali
↓
Clone repository
↓
Run setup.sh
↓
Red Team toolbox ready

The repository remains the single configuration source for every environment.