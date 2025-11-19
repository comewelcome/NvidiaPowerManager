# NvidiaPowerManager

## Gestionnaire de Modes de Performance GPU NVIDIA pour Linux

Ce projet fournit une solution complète pour gérer et optimiser les performances et la consommation d'énergie des cartes graphiques NVIDIA sous Linux. Il permet aux utilisateurs de basculer facilement entre différents modes de performance (Éco, Intermédiaire, Performance) via un script unifié, des raccourcis de bureau et un service systemd pour une application automatique au démarrage.

### Fonctionnalités

*   **Trois Modes de Performance** :
    *   **Éco (Eco)** : Optimisé pour une faible consommation d'énergie (100W), fréquence verrouillée à 210 MHz.
    *   **Intermédiaire (Med)** : Équilibre performance/conso (200W), OC modéré, fréquence 1000-1200 MHz.
    *   **Performance (Perf)** : Performance maximale (300W), OC élevé, fréquences débloquées.
*   **Script Unifié** : Un seul script `gpu-manager.sh` gère à la fois la puissance (via `nvidia_oc`) et les fréquences (via `nvidia-smi`).
*   **Installation Automatique** : Le script `install.sh` configure automatiquement le service et les raccourcis en fonction de l'emplacement du projet.

### Prérequis

*   Linux avec pilotes NVIDIA propriétaires.
*   `nvidia-smi` installé.
*   `nvidia_oc` (fourni dans ce dépôt).
*   Droits root (pour appliquer les changements).

### Installation

1.  Clonez ou téléchargez ce dépôt.
2.  Ouvrez un terminal dans le dossier du projet.
3.  Rendez le script d'installation exécutable et lancez-le :

    ```bash
    chmod +x install.sh
    ./install.sh
    ```

    Cela va :
    *   Configurer et installer le service `gpu-mode-med.service` (lance le mode Med au démarrage).
    *   Créer et installer les raccourcis bureau (`gpu-eco.desktop`, etc.) dans `~/.local/share/applications/`.

### Utilisation

#### Via le Terminal

Utilisez le script `gpu-manager.sh` avec les droits root :

```bash
sudo ./gpu-manager.sh eco   # Mode Éco
sudo ./gpu-manager.sh med   # Mode Intermédiaire
sudo ./gpu-manager.sh perf  # Mode Performance
```

#### Via le Bureau

Cherchez "GPU" dans votre menu d'applications. Vous trouverez :
*   **GPU Eco Mode**
*   **GPU Medium Mode**
*   **GPU Performance Mode**

Lors du lancement, le système vous demandera votre mot de passe (via `pkexec`) pour appliquer les changements.

### Structure du Projet

```
.
├── gpu-manager.sh          # Script principal de gestion (remplace gpu-tuning.sh et gpuconfig.sh)
├── install.sh              # Script d'installation automatique
├── nvidia_oc               # Outil d'overclocking
├── README.md               # Documentation
└── (Fichiers générés)      # .service et .desktop générés par install.sh
```

### Licence

MIT