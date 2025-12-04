# GlobalGroupTravel CRM – Architecture du projet

## 1. Objectif du dépôt

Ce dépôt contient le code back-end Apex et l’architecture de la base de données Salesforce pour la solution CRM de GlobalGroupTravel (GGT).  
Il regroupe :
- Le modèle de données (dont l’objet custom Trip__c),
- Les triggers et classes Apex (services, batchs, helpers),
- Les tests unitaires,
- La documentation et les rapports de tests.

## 2. Structure du projet

- `force-app/main/default/objects/`
  - Métadonnées des objets Salesforce (standard étendus + Trip__c).
- `force-app/main/default/classes/`
  - Classes Apex métier (services, batchs, helpers).
  - Classes de test associées.
- `force-app/main/default/triggers/`
  - Triggers Apex sur Opportunity, Trip__c, etc.
- `docs/`
  - `01-architecture-projet.md` : architecture globale du projet.
  - Autres documents techniques et fonctionnels (modèle de données, liste des fonctionnalités, etc.).
- `tests-reports/`
  - Rapports de tests Apex et fichiers de couverture de code exportés depuis Salesforce.

## 3. Conventions de nommage (résumé)

- Préfixe projet : `GGT_` pour les classes Apex.
- Classes de service : `GGT_<Domaine>Service` (ex. `GGT_TripService`).
- Classes de handler de trigger : `GGT_<Objet>Handler` (ex. `GGT_OpportunityTripHandler`).
- Batch Apex : `GGT_<NomBatch>Batch` (ex. `GGT_TripCancellationBatch`).
- Data factory de test : `GGT_TestDataFactory`.
- Classes de test : même nom que la classe cible + `Test` (ex. `GGT_TripServiceTest`).

