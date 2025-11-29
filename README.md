# Analyse des sinistres en assurance habitation et application Shiny de calcul de prime

## 📌 Aperçu du projet

Ce projet porte sur l’analyse et la tarification des sinistres en assurance habitation. L’objectif principal est de comprendre comment différentes caractéristiques d’un assuré, d’une maison et d’un contrat influencent la fréquence et la sévérité des sinistres, puis d’utiliser ces résultats pour estimer une prime actuarielle juste.

L’approche adoptée repose sur la méthode classique en actuariat, selon laquelle :

$$
\text{Prime pure} = \text{Fréquence attendue} \times \text{Sévérité attendue}
$$

Les deux composantes ont été modélisées séparément afin d’obtenir une estimation plus précise du risque.

------------------------------------------------------------------------

## 🎯 Objectifs

-   Étudier les facteurs déterminants du risque en assurance habitation
-   Construire des modèles pour prédire :
    -   **La fréquence des sinistres** (nombre de sinistres)
    -   **La sévérité des sinistres** (montant moyen des indemnités)
-   Calculer la **prime pure** pour chaque contrat
-   Développer une **application Shiny** permettant de calculer la prime selon les caractéristiques sélectionnées par l’utilisateur

------------------------------------------------------------------------

## 🛠️ Méthodologie et modèles

### 🔹 Préparation des données

Les données ont été nettoyées, recodées et enrichies afin d’obtenir des variables explicatives pertinentes pour la modélisation.

### 🔹 Modèle de fréquence

La fréquence des sinistres a été modélisée au moyen d’un **GLM (modèle linéaire généralisé)** avec une distribution de Poisson. Les variables explicatives comprennent notamment :

-   Région ou territoire
-   Condition du toit
-   Niveau de franchise
-   Réduction multiproduit
-   Catégorie de cote de crédit

### 🔹 Modèle de sévérité

La sévérité a été analysée à l’aide de modèles continus adaptés aux montants monétaires. Plusieurs distributions et algorithmes ont été testés, tels que :

-   Régression lognormale
-   Régression Gamma
-   Méthodes d’apprentissage automatique

Le meilleur modèle a été sélectionné sur la base des critères de performance et de robustesse.

------------------------------------------------------------------------

## 💰 Calcul de la prime pure

La prime est obtenue par :

$$
\text{Prime pure} = \widehat{\lambda} \times \widehat{C}
$$

-   $\widehat{\lambda}$ : fréquence prédite du sinistre\
-   $\widehat{C}$ : coût moyen prédit du sinistre

------------------------------------------------------------------------

## 🚀 Application web Shiny

Une application interactive a été développée avec **R Shiny**.\
Elle permet aux utilisateurs de :

-   Choisir différentes caractéristiques d’un contrat
-   Voir l’impact de chaque facteur sur le risque
-   Calculer automatiquement la prime pure
-   Comparer plusieurs profils d’assurés

L’interface rend l’analyse actuarielle accessible même aux utilisateurs non techniques.

------------------------------------------------------------------------

## 🧾 Technologies utilisées

-   **R** : Ingénierie de données et modélisation statistique
-   **Python** : Nettoyae et analyse exploratoire des données
-   **Shiny** : interface web interactive
-   **Visualisation** : base R, ggplot2, matplotlib
