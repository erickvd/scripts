#!/bin/bash
echo "Provisioning d'une machine"
echo "=========================="
echo
# Vérifier si le script est exécuté avec sudo
if [ "$(id -u)" != "0" ]; then
  echo "Error: Ce script doit être exécuté avec sudo."
  echo "Veuillez utiliser la commande suivante : "
  echo "wget -q -O - http://ansible.lan.ekla-danse.be/scripts/prov.sh | sudo bash"
  exit 1
fi

# Créer un compte pour semaphore
echo "Création de l'utilisateur semaphore"
if ( ! id semaphore &> /dev/null )
then
useradd -r -s /bin/bash -m semaphore
usermod -p "SEMAPHORE_PWD" semaphore # voir fichier env
else
echo "Utilisateur déja présent."
fi

# Déployer clé SSH
echo "Installation clé SSH"
if ( ! [ -d /home/semaphore/.ssh ] );
then
mkdir /home/semaphore/.ssh
chown semaphore:semaphore /home/semaphore/.ssh
chmod 700 /home/semaphore/.ssh
fi

SEM_SSH_KEY="" # voir fichier env
if ( ! grep "${SEM_SSH_KEY}" /home/semaphore/.ssh/authorized_keys &> /dev/null );
then
echo "${SEM_SSH_KEY}" >> /home/semaphore/.ssh/authorized_keys
fi


# Configurer sudoers
echo "Configuration sudoers"
if ( ! [ -f /etc/sudoers.d/semaphore ] );
then
echo "semaphore ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/semaphore
chown root:root /etc/sudoers.d/semaphore
chmod 640 /etc/sudoers.d/semaphore
fi