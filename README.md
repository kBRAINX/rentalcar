# Projet Spring Boot en Clean Architecture

## Description
Ce projet implémente une application Spring Boot suivant les principes de la Clean Architecture, avec l'utilisation des design patterns Builder et Factory pour gérer efficacement les communications avec des APIs externes. L'architecture est conçue pour permettre le stockage des données générales dans des APIs externes tout en conservant des données spécifiques dans notre propre base de données.

## Structure du Projet

```
projet-clean-architecture/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── example/
│   │   │           └── cleanarchitecture/
│   │   │               ├── CleanArchitectureApplication.java
│   │   │               ├── domain/
│   │   │               │   ├── model/
│   │   │               │   ├── repository/
│   │   │               │   ├── service/
│   │   │               │   └── exception/
│   │   │               ├── application/
│   │   │               │   ├── service/
│   │   │               │   ├── dto/
│   │   │               │   └── mapper/
│   │   │               ├── infrastructure/
│   │   │               │   ├── persistence/
│   │   │               │   │   ├── entity/
│   │   │               │   │   ├── repository/
│   │   │               │   │   └── adapter/
│   │   │               │   ├── external/
│   │   │               │   │   ├── api/
│   │   │               │   │   │   ├── client/
│   │   │               │   │   │   ├── dto/
│   │   │               │   │   │   ├── mapper/
│   │   │               │   │   │   └── factory/
│   │   │               │   │   └── notification/
│   │   │               │   │       ├── client/
│   │   │               │   │       ├── dto/
│   │   │               │   │       └── adapter/
│   │   │               │   └── config/
│   │   │               └── presentation/
│   │   │                   ├── controller/
│   │   │                   ├── dto/
│   │   │                   ├── mapper/
│   │   │                   └── exception/
│   │   └── resources/
│   │       ├── application.yml
│   │       ├── application-dev.yml
│   │       └── application-prod.yml
│   └── test/
│       └── java/
│           └── com/
│               └── example/
│                   └── cleanarchitecture/
│                       ├── domain/
│                       ├── application/
│                       ├── infrastructure/
│                       └── presentation/
├── .gitignore
├── build.gradle
└── README.md
```

## Description Détaillée des Couches de l'Architecture

### 1. Domain (Couche de Domaine)

C'est le cœur de l'application, indépendant de toute technologie ou framework externe.

#### model/
- Contient les entités du domaine qui représentent les concepts métier
- Ces classes sont pures et ne contiennent que des données et la logique métier
- Exemple: `User.java`, `Product.java`, etc.

#### repository/
- Interfaces définissant les contrats pour la persistance des entités du domaine
- N'implémente pas la persistance, seulement les contrats
- Exemple: `UserRepository.java`, `ProductRepository.java`

#### service/
- Interfaces définissant les services métier
- Exemple: `UserService.java`, `ProductService.java`, etc.

#### exception/
- Exceptions spécifiques au domaine
- Exemple: `DomainException.java`, `UserNotFoundException.java`

### 2. Application (Couche d'Application)

Cette couche orchestrent les flux de données entre la couche de présentation et le domaine.

#### service/
- Implémentations des interfaces de service du domaine
- Orchestre les appels aux repositories
- Exemple: `UserServiceImpl.java`, `ProductServiceImpl.java`

#### dto/
- Objets de transfert de données utilisés par la couche d'application
- Exemple: `UserDTO.java`, `ProductDTO.java`

#### mapper/
- Classes responsables de la conversion entre les objets du domaine et les DTOs
- Exemple: `UserMapper.java`, `ProductMapper.java`

### 3. Infrastructure (Couche d'Infrastructure)

Cette couche contient toutes les implémentations techniques et les adaptateurs pour les services externes.

#### persistence/entity/
- Entités JPA pour la persistance des données
- Mappent les entités du domaine vers la base de données
- Exemple: `UserEntity.java`, `ProductEntity.java`

#### persistence/repository/
- Implémentations Spring Data JPA des repositories
- Exemple: `UserJpaRepository.java`, `ProductJpaRepository.java`

#### persistence/adapter/
- Adaptateurs qui implémentent les interfaces de repository du domaine
- Utilisent les repositories JPA
- Exemple: `UserRepositoryAdapter.java`, `ProductRepositoryAdapter.java`

#### external/api/client/
- Clients pour les APIs externes
- Utilisent RestTemplate, WebClient ou Feign
- Exemple: `ExternalApiClient.java`, `ThirdPartyServiceClient.java`

#### external/api/dto/
- DTOs pour les APIs externes
- Exemple: `ExternalUserDTO.java`, `ThirdPartyProductDTO.java`

#### external/api/mapper/
- Mappers pour convertir entre les DTOs externes et les modèles du domaine
- Exemple: `ExternalUserMapper.java`, `ThirdPartyProductMapper.java`

#### external/api/factory/
- **Factories** pour créer les objets complexes liés aux APIs externes
- Exemple: `ExternalUserFactory.java`, `ExternalRequestFactory.java`

#### external/notification/
- Clients et adaptateurs pour les services de notification
- Exemple: `EmailNotificationClient.java`, `PushNotificationAdapter.java`

#### config/
- Configuration Spring Boot
- Exemple: `RestTemplateConfig.java`, `SecurityConfig.java`

### 4. Presentation (Couche de Présentation)

Cette couche gère l'exposition des API REST et la conversion des données.

#### controller/
- Contrôleurs REST
- Exemple: `UserController.java`, `ProductController.java`

#### dto/
- DTOs pour l'API REST
- Utilise le pattern **Builder** pour la construction flexible des objets
- Exemple: `UserRequestDTO.java`, `UserResponseDTO.java`

#### mapper/
- Convertisseurs entre les DTOs de la présentation et les DTOs de l'application
- Exemple: `UserRestMapper.java`, `ProductRestMapper.java`

#### exception/
- Gestionnaires d'exceptions globaux
- Exemple: `GlobalExceptionHandler.java`, `ApiError.java`

## Implémentation des Design Patterns

### Pattern Builder

Le pattern Builder est implémenté dans:

1. **presentation/dto/**: Pour construire de manière fluide et flexible les DTOs de requête et de réponse
   ```java
   public class UserResponseDTO {
       private final Long id;
       private final String name;
       private final String email;
       // autres attributs

       private UserResponseDTO(Builder builder) {
           this.id = builder.id;
           this.name = builder.name;
           this.email = builder.email;
           // initialisation des autres attributs
       }

       public static class Builder {
           private Long id;
           private String name;
           private String email;
           // autres attributs

           public Builder id(Long id) {
               this.id = id;
               return this;
           }

           public Builder name(String name) {
               this.name = name;
               return this;
           }

           public Builder email(String email) {
               this.email = email;
               return this;
           }

           // autres méthodes builder

           public UserResponseDTO build() {
               return new UserResponseDTO(this);
           }
       }
   }
   ```

2. **external/api/dto/**: Pour construire les objets complexes envoyés aux APIs externes
   ```java
   public class ExternalUserRequest {
       // attributs et implémentation du Builder
   }
   ```

### Pattern Factory

Le pattern Factory est implémenté dans:

1. **external/api/factory/**: Pour créer les divers objets nécessaires à l'interaction avec les APIs externes
   ```java
   public class ExternalRequestFactory {
       public ExternalUserRequest createUserRequest(User user, AdditionalData additionalData) {
           return new ExternalUserRequest.Builder()
                   .withUserId(user.getId())
                   .withUsername(user.getUsername())
                   .withAdditionalField1(additionalData.getField1())
                   .withAdditionalField2(additionalData.getField2())
                   .build();
       }
       
       public ExternalProductRequest createProductRequest(Product product) {
           // Création d'une requête pour un produit
       }
   }
   ```

2. **external/notification/client/**: Pour créer différents types de notifications
   ```java
   public class NotificationFactory {
       public Notification createEmailNotification(User user, String subject, String content) {
           return new EmailNotification(user.getEmail(), subject, content);
       }
       
       public Notification createPushNotification(User user, String title, String message) {
           return new PushNotification(user.getDeviceToken(), title, message);
       }
   }
   ```

## Communication avec les APIs Externes

La stratégie pour communiquer avec les APIs externes et stocker les données est la suivante:

1. Les données générales sont stockées dans l'API externe
2. Les données supplémentaires spécifiques à notre application sont stockées dans notre propre base de données
3. Un identifiant commun est utilisé pour lier les deux ensembles de données

### Workflow typique:

1. Réception d'une requête depuis la couche de présentation
2. Transformation en objet du domaine
3. Le service du domaine traite la requête
4. Pour les données externes:
   - Utilisation de la Factory pour créer les objets de requête
   - Appel à l'API externe via le client approprié
   - Stockage de l'identifiant externe dans notre base de données
5. Pour les données internes:
   - Stockage des données spécifiques dans notre base de données
   - Association avec l'identifiant externe
6. Transformation du résultat en DTO de réponse
7. Renvoi de la réponse

## Configuration et Déploiement

Ce projet utilise Gradle comme outil de build et de gestion des dépendances.

### Dépendances principales:
- Spring Boot Starter Web
- Spring Boot Starter Data JPA
- Spring Boot Starter Validation
- Spring Cloud OpenFeign (pour les clients REST)
- Lombok (pour réduire le boilerplate)
- Mapstruct (pour faciliter le mapping entre objets)
- H2 Database (pour le développement)
- Spring Boot Starter Test
- Spring Boot Starter Security

### Profils de configuration:
- **application.yml**: Configuration commune
- **application-dev.yml**: Configuration de développement (H2, logging détaillé, etc.)
- **application-prod.yml**: Configuration de production (base de données réelle, etc.)

## Tests

Chaque couche dispose de ses propres tests unitaires et d'intégration:

- Tests unitaires pour la logique du domaine
- Tests d'intégration pour les repositories
- Tests unitaires pour les contrôleurs REST avec MockMvc
- Tests avec WireMock pour simuler les APIs externes

## Démarrage

1. Cloner le repository: `git clone https://github.com/example/clean-architecture-project.git`
2. Accéder au dossier: `cd clean-architecture-project`
3. Compiler le projet: `./gradlew build`
4. Exécuter l'application: `./gradlew bootRun`

L'application sera accessible à l'adresse: http://localhost:8080

## Conclusion

Cette architecture permet une séparation claire des responsabilités et facilite la maintenance et l'évolution de l'application. Les patterns Builder et Factory permettent de gérer efficacement la complexité des interactions avec les APIs externes tout en gardant le code propre et modulaire.
