# Conseils

## Python
Utilisez PyEnv et les virtualenv de python pour ne pas installer pleins de libs dans tous les sens
PyEnv va vous permettre de gérer plusieurs version de python ce qui peut être utile, pour ce projet par exemple, après avoir installé pyenv
```bash
pyenv install 3.13
pyenv local 3.13 # ça va créer un fichier .python-version dans le répertoire local au moins on sait que ça fonctionne avec la version X.Y.Z de Python
python -m venv .venv # On crée un dossier .venv qui contiendra les libs python pour le projets, comme ça quand on supprime le projet on ne conserve pas les lib
source .venv/bin/activate # On active le venv
pip install redis flask # On installe
pip freeze > azure-vote/requirements.txt # On freeze les versions, comme ça on évite de casser le projet sur un simple upgrade 
```
Cette partie est utile pour le dev en local surtout ! Si vous êtes sur un repositorie git pensez a toujours exclure le dossier .venv dans le fichier `.gitignore`

## Docker

On peut gérer le build directement depuis le `docker-compose.yml` avec 
```yaml
services:
  azure-vote-front:
    build:
      context: .
```
ça évite de faire un `docker build` puis `docker compose up`.

Docker Desktop est devenu payant pour les entreprises depuis quelques années, vous pouvez utiliser différentes alternatives comme Rancher, OrbStack ou Podman

## Packer
Il se peut dans certains cas qu'il existe des scripts de déploiement Ansible pour une application et qu'on vous demande de migrer vers Docker, dans ce cas Packer vous permet de répondre a cette demande sans réinventer la roue, donc du temps d'économisé et surtout on conserve la même structure ce qui est de fait plus simple pour les équipe Ops.
Le `Dockerfile` et le `docker-compose.yml` ne sont plus nécessaires dans ce cas. Les Ops n'ont pas besoin de connaitre ou maitriser Docker dans ce cas là.

Les bloc de post-processor permettent d'executer des tâches après le build, comme le nommage de l'image et aussi le push sur le registry.
L'autre avantage c'est qu'on peut aussi build sur différentes platformes, Ubuntu, Debian, Red Hat, CentOS etc. en parrallèle donc si on a besoin de faire un portage sur un autre système, ou une autre architecture processeur (amd64/arm64) on peut créer rapidement ça avec Packer en conservant un système simple.

> **Attention :**: Un fichier de configuration Packer doit toujours avoir l'extension `.pkr.hcl`