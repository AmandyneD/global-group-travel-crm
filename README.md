# GlobalGroupTravel CRM – Back-end Apex & Base de données

Ce projet implémente le back-end et la base de données de la solution CRM Salesforce pour **GlobalGroupTravel**, un fournisseur de voyages de groupe.

## Objectifs

- Modéliser les objets métiers : 
  - Clients (Account)
  - Ventes (Opportunity)
  - Contrats (Contract)
  - Utilisateurs (User)
  - Historique des interactions (Task)
  - Voyages de groupe (Trip__c)
- Implémenter la logique métier en Apex (triggers, services, batchs).
- Assurer la sécurité et la visibilité des données selon les règles Salesforce.
- Atteindre une couverture de code supérieure aux exigences de Salesforce.

## Structure du projet

- `force-app/main/default/objects/` : objets (dont `Trip__c`).
- `force-app/main/default/classes/` : classes Apex + tests.
- `force-app/main/default/triggers/` : triggers Apex.
- `docs/` : documentation technique et fonctionnelle.
- `tests-reports/` : rapports de tests et de couverture.

## Outils

- Salesforce CLI (sf)
- VS Code
- Git & GitHub

