#  Data Battle IA PAU 2026 – Prédiction de la fin des alertes orageuses

## 👥 Équipe
- Nom de l’équipe : The Predictors
- Membres :
  - BOHISSOU Ibigbé Amour Sabin
  - AGOSSOUVO Tolidji Chantelas Juste
  - DEFFON Deffongé Flora Fierté
  - AGBAMATE Paraclet
---

## 🎯 Problématique

Les infrastructures sensibles comme les aéroports doivent interrompre certaines opérations lors des épisodes orageux afin de garantir la sécurité des personnels et des équipements.  
Si l’anticipation de l’arrivée des orages est aujourd’hui relativement maîtrisée, l’estimation précise du moment de leur dissipation reste un défi majeur.

Actuellement, les alertes sont maintenues pendant une durée fixe après le dernier éclair observé, ce qui peut entraîner des interruptions d’activité plus longues que nécessaire.

L’objectif de ce projet est de développer un modèle prédictif probabiliste capable d’estimer en temps réel la fin d’un épisode orageux à partir de la dynamique spatio-temporelle des éclairs observés autour de plusieurs aéroports européens.

---

## 💡 Solution proposée

Nous proposons une architecture hybride combinant :

- une approche d’**analyse de survie** permettant de modéliser le temps restant avant la fin de l’orage ;
- un modèle de **machine learning non linéaire (XGBoost)** pour améliorer la capacité de discrimination.

Une phase d’analyse exploratoire a également permis d’identifier différents **types d’orages** à l’aide d’une méthode de clustering non supervisé.

Cette approche permet :

- d’estimer une probabilité de fin d’alerte en temps réel ;
- de réduire les interruptions opérationnelles inutiles ;
- d’améliorer la prise de décision dans un contexte de risque météorologique.

---

## ⚙️ Stack technique

- **Langages :**
  - R
  - Python

- **Frameworks / Librairies :**
  - XGBoost
  - dplyr
  - ggplot2
  - survival
  - scikit-learn

- **Outils :**
  - Git / GitHub
  - RStudio
  - Jupyter Notebook

- **IA :**
  - Modélisation AFT (Accelerated Failure Time)
  - Machine Learning supervisé
  - Clustering non supervisé (K-means)

---

## 🚀 Installation & exécution

### Prérequis

- R (≥ 4.2)
- Python (≥ 3.9)
- Git

### Installation

Cloner le repository :

```bash
git clone https://github.com/username/databattle-orage.git
cd databattle-orage
