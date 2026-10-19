# CHU Hospital App - Application de Digitalisation Hospitalière

## 📱 Description
Application Flutter complète pour la gestion hospitalière avec support multiplateforme (Mobile, Tablette, Desktop) et trois rôles d'utilisateurs : Agent, Médecin et Administrateur.

## ✨ Fonctionnalités

### 🔐 Authentification
- Connexion sécurisée avec Supabase Auth
- Gestion des rôles (Admin, Agent, Doctor, Nurse)
- Réinitialisation de mot de passe
- Contrôle d'accès basé sur les rôles (RBAC)

### 👥 Gestion des Patients
- Création et recherche de patients
- Historique des hospitalisations
- Profil patient avec informations personnelles
- Identification unique (PAT-2024-XXXXXX)

### 🛏️ Gestion des Lits
- Structure hiérarchique : Bâtiment > Étage > Aile > Chambre > Lit
- États des lits : Libre, Occupé, Nettoyage
- Types de lits : Standard, Bariatrique, Pédiatrique, Soins intensifs
- Visualisation par service
- Alertes de saturation

### 🏥 Gestion des Admissions
- Processus d'admission en 3 étapes
- Affectation de lit automatique
- Prescription de sortie par médecin
- Libération de lit par infirmier
- Historique complet des séjours

### 📊 Tableaux de Bord
- **Agent** : Admissions, gestion des lits, patients
- **Médecin** : Mes patients, historique, prescriptions
- **Admin** : Statistiques globales, gestion des utilisateurs, parc de lits

### 📱 Navigation Responsive
- **Smartphone** : Navigation inférieure avec 4 onglets
- **Tablette** : Navigation latérale réductible
- **Desktop** : Navigation latérale fixe avec affichage complet

## 🚀 Installation

### Prérequis
- Flutter 3.0+
- Supabase account
- Git

### Configuration

1. **Cloner le projet**
```bash
cd flutter_supa_plate/plate_auth
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Configurer Supabase**

   a. Créer un compte sur [supabase.com](https://supabase.com)
   
   b. Créer un nouveau projet
   
   c. Exécuter le schéma SQL : [lib/database/supabase_schema.sql](lib/database/supabase_schema.sql)
   
   d. Récupérer vos clés :
      - URL Supabase
      - Clé anonyme (ANON_KEY)
   
   e. Mettre à jour [lib/main.dart](lib/main.dart) :
   ```dart
   await Supabase.initialize(
     url: 'YOUR_SUPABASE_URL',
     anonKey: 'YOUR_SUPABASE_ANON_KEY',
   );
   ```

4. **Lancer l'application**
```bash
flutter run
```

## 📁 Structure du Projet

```
lib/
├── main.dart                      # Point d'entrée
├── app/
│   ├── router/
│   │   └── app_router.dart       # Configuration de la navigation
│   └── screens/
│       ├── auth/
│       │   └── login_screen.dart
│       ├── agent/
│       │   └── agent_dashboard_screen.dart
│       ├── doctor/
│       │   └── doctor_dashboard_screen.dart
│       └── admin/
│           └── admin_dashboard_screen.dart
├── config/
│   ├── theme/
│   │   └── app_theme.dart        # Configuration du thème
│   └── constants/
│       └── app_constants.dart    # Constantes
├── models/
│   ├── user_model.dart
│   ├── patient_model.dart
│   ├── bed_model.dart
│   ├── admission_model.dart
│   └── index.dart
├── services/
│   ├── auth_service.dart         # Service authentification
│   ├── patient_service.dart      # Service patients
│   ├── bed_service.dart          # Service lits
│   └── admission_service.dart    # Service admissions
├── providers/
│   ├── auth_providers.dart       # Providers authentification
│   ├── patient_providers.dart    # Providers patients
│   ├── bed_providers.dart        # Providers lits
│   └── admission_providers.dart  # Providers admissions
└── database/
    └── supabase_schema.sql       # Schéma base de données
```

## 🔑 Comptes de Démonstration

Après configuration de Supabase, créez ces utilisateurs :

| Rôle | Email | Mot de passe |
|------|-------|-------------|
| Admin | admin@chu.tg | password |
| Médecin | doctor@chu.tg | password |
| Agent | agent@chu.tg | password |

## 🎨 Thème

- **Couleur primaire** : Vert (#2E7D32)
- **Couleur secondaire** : Bleu (#1976D2)
- **Couleur d'accent** : Orange (#FF6F00)
- **Police** : Poppins

### Couleurs des lits
- 🟢 **Libre** : Vert (#4CAF50)
- 🔴 **Occupé** : Rouge (#F44336)
- 🟠 **Nettoyage** : Orange (#FF9800)

## 📦 Dépendances Principales

- **supabase_flutter** : Backend et base de données
- **flutter_riverpod** : Gestion d'état
- **go_router** : Navigation
- **flutter_screenutil** : Responsive design
- **responsive_builder** : Layouts responsifs
- **mobile_scanner** : Scanner QR
- **table_calendar** : Calendrier

## 🔐 Sécurité

- Authentification Supabase Auth
- Row Level Security (RLS) activée
- Contrôle d'accès basé sur les rôles
- Données sensibles chiffrées
- Logs d'activité pour audit

## 🔄 Flux d'Admission

```
1. Recherche/Création Patient
        ↓
2. Sélection Service & Lit
        ↓
3. Confirmation & Médecin
        ↓
4. Admission Active
        ↓
5. Prescription Sortie (Médecin)
        ↓
6. Libération Lit (Infirmier)
        ↓
7. Admission Archivée
```

## 📊 Structure Hiérarchique des Lits

```
Hôpital
├── Bâtiment A
│   ├── RDC
│   │   ├── Aile Est
│   │   │   ├── Chambre 101 (Maternité)
│   │   │   │   ├── Lit 1 (Libre)
│   │   │   │   ├── Lit 2 (Occupé)
│   │   │   │   └── Lit 3 (Nettoyage)
│   │   │   └── Chambre 102 (Maternité)
│   │   └── Aile Ouest
│   ├── 1er étage
│   └── 2ème étage
├── Bâtiment B
└── Bâtiment Central
```

## 🎯 Services Disponibles

| Service | Description |
|---------|-------------|
| Maternité | Obstétrique et gynécologie |
| Chirurgie | Chirurgie générale |
| Médecine interne | Médecine générale |
| Pédiatrie | Soins des enfants |
| Urgences | Service d'urgence |
| Soins intensifs | Unité de soins intensifs |
| Cardiologie | Maladies du cœur |
| Orthopédie | Traumatologie |

## 🛠️ Améliorations Futures

- [ ] Notifications en temps réel
- [ ] Export PDF des rapports
- [ ] Graphiques avancés
- [ ] Mode hors ligne
- [ ] Support multilingue
- [ ] Téléchargement de documents médicaux
- [ ] Integration SMS pour alertes
- [ ] Dossier médical électronique complet

## 📞 Support

Pour toute question ou bug :
1. Vérifier la documentation
2. Consulter les logs de la console
3. Vérifier la connexion Supabase
4. Vérifier les permissions RLS

## 📄 Licence

Ce projet est propriété du CHU Togo.

## 👨‍💻 Développement

### Créer un nouveau screen

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewScreen extends ConsumerWidget {
  const NewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('New Screen')),
      body: Center(child: Text('Content here')),
    );
  }
}
```

### Ajouter un nouveau service

1. Créer une classe dans `lib/services/`
2. Créer un provider dans `lib/providers/`
3. Utiliser le provider dans les screens

## 🌐 Déploiement

### iOS
```bash
flutter build ios
```

### Android
```bash
flutter build apk
```

### Web
```bash
flutter build web
```

---

**Dernière mise à jour** : 2026-06-19
**Version** : 1.0.0
