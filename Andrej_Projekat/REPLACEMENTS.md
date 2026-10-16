# Replacement Documentation - Andrej Project (Potion Shop)

## Cloning Overview

The original **Online Shop** (Cafe Shop) project was cloned and converted into **Andrej Project - Potion Shop**.

## Strings Replaced

### 1. Containers and Service Names
```
cafeshop                    -> potionshop
cafeShop                    -> potionShop
CafeShop                    -> PotionShop
Cafe                        -> Potion
cafe                        -> potion
```

### 2. Project Names
```
mina                        -> andrej
Mina                        -> Andrej
MINA                        -> ANDREJ
```

### Where the replacements were applied:

#### Docker Compose (`docker-compose.yml`)
- `cafeshop-mysql` -> `potionshop-mysql`
- `cafeshop-config-server` -> `potionshop-config-server`
- `cafeshop-eureka` -> `potionshop-eureka`
- `cafeshop-api-gateway` -> `potionshop-api-gateway`
- `cafeshop-user-service` -> `potionshop-user-service`
- `cafeshop-order-service` -> `potionshop-order-service`
- `cafeshop-payment-service` -> `potionshop-payment-service`
- `cafeshop-catalog-service` -> `potionshop-catalog-service`
- `cafeshop-web-app` -> `potionshop-web-app`
- `cafeshop-net` -> `potionshop-net`
- `MYSQL_DATABASE: cafeShop` -> `MYSQL_DATABASE: potionShop`

#### Database (`init-db/init.sql`)
```sql
CREATE DATABASE IF NOT EXISTS cafeShop;
-> CREATE DATABASE IF NOT EXISTS potionShop;

USE cafeShop;
-> USE potionShop;
```

#### Java Services

All services were processed and the strings were replaced in:
- Package names
- Class comments
- Class names (where relevant)
- Configuration and properties

#### Property Files

All `application.properties` files were kept with a similar structure because they do not contain direct references to "cafe" or "mina".

---

## Products - Changes

### Original Products -> New Products

| ID | Original | New | Price | Description |
|----|----------|------|------|------|
| 1 | Espresso | Mana Potion | 250 GOLD | Powerful magic drink - full 100 mana |
| 2 | Cappuccino | HP Potion | 300 GOLD | Healing drink - restores health |
| 3 | Latte | Stamina Elixir | 280 GOLD | Energy for long journeys |
| 4 | Croissant | Poison Vial | 400 GOLD | Dangerous vial with potent poison |
| 5 | Chocolate cake | Speed Elixir | 350 GOLD | Boost your speed to the maximum |

### Original Extras -> New Extras

| ID | Original | New | Price |
|----|----------|------|------|
| 1 | Vanilla syrup | Honey Extract | 50 GOLD |
| 2 | Almond milk | Fairy Dust | 100 GOLD |
| 3 | Whipped cream | Cloud Essence | 80 GOLD |
| 4 | Extra espresso | Concentrated Essence | 120 GOLD |

---

## Allergens - Kept As They Were

The allergens were kept identical because they appear in the catalog and are not specific to coffee:
- Gluten
- Lactose
- Eggs
- Walnuts
- Soy

---

## Files Cloned and Replaced

### Directories Cloned:
1. `user-service/` - Cloned with replacement
2. `order-service/` - Cloned with replacement
3. `payment-service/` - Cloned with replacement
4. `catalog-service/` - Cloned with replacement
5. `api-gateway/` - Cloned with replacement
6. `eureka-server/` - Cloned with replacement
7. `config-server/` - Cloned with replacement
8. `web-app/` - Cloned with replacement

### Files Replaced:
- `*.java` - All Java source files
- `*.properties` - Application properties
- `*.xml` - Maven POM files (kept unchanged because they had no references)
- `*.yml`, `*.yaml` - YAML configurations
- `*.sql` - SQL init scripts
- `*.json` - JSON files (Postman collection renamed)
- `Dockerfile` - Docker files
- `*.md` - Markdown documentation

### Files Excluded (not copied):
- `/target/` - Compiled files
- `.git/` - Git history
- `__MACOSX/` - Metadata
- `.DS_Store` - Mac system files
- `*.class` - Compiled Java classes

---

## Replacements by File

### Property Files
All `application.properties` files were copied without changes because they do not contain references to "cafe" or "mina".

**Examples:**
```properties
spring.application.name=user-service
server.port=8003
# The rest kept as in the original
```

### Java Files
All Java files were copied and the strings were replaced in comments and documentation.

**Examples of replacements:**
```java
// Original:
// Cafe Shop Microservice
// Developed by Mina

// New:
// Potion Shop Microservice
// Developed by Andrej
```

### Docker Compose
```yaml
# Original:
container_name: cafeshop-mysql

# New:
container_name: potionshop-mysql
```

### SQL Scripts
```sql
-- Original:
CREATE DATABASE IF NOT EXISTS cafeShop;

-- New:
CREATE DATABASE IF NOT EXISTS potionShop;
```

---

## Postman Collection

### Renamed File:
```
Original: CafeShop.postman_collection.json
New:      PotionShop.postman_collection.json
```

### Replaced Strings in the Collection:
- All references to `/api/cafe` -> `/api/potion`
- All references to `cafeshop` -> `potionshop` (in URLs and variables)
- All references to `CafeShop` -> `PotionShop`

---

## Directory Structure

### Original:
```
Online_shop_project/
├── docker-compose.yml
├── CafeShop.postman_collection.json
├── init-db/init.sql
└── [services]
```

### New:
```
Potion_Shop_Project/Andrej_Projekat/
├── docker-compose.yml
├── PotionShop.postman_collection.json
├── init-db/init.sql
├── config-repo/
└── [services]
```

---

## Replaced Strings per Service

### User Service
```
Files: UserServiceApplication.java, UserService.java, UserController.java, etc.
Replacements: Comments mentioning "cafe" -> "potion"
              Comments mentioning "mina" -> "andrej"
```

### Catalog Service
```
Files: ProductService.java, ExtraService.java, AllergenService.java
Replacements: Product descriptions mentioning cafe -> potion
              Extra descriptions mentioning cafe -> potion
```

### Order Service
```
Files: OrderService.java, OrderController.java
Replacements: Order status comments
```

### Payment Service
```
Files: PaymentService.java, CardService.java
Replacements: Transaction comments
```

---

## Project Version

- **Original**: Online Shop (CafeShop)
- **New Version**: Andrej Project (Potion Shop)
- **Version**: 1.0.0-SNAPSHOT
- **Java**: 21
- **Spring Boot**: 3.3.7
- **Spring Cloud**: 2023.0.3

---

## How to Use the Replaced Files

1. **Copy the project to your preferred location**
2. **Set the environment variables**:
   ```bash
   export DB_PASSWORD=your_password
   ```
3. **Start Docker Compose**:
   ```bash
   docker-compose up -d
   ```
4. **Access the application**:
   - Web: http://localhost:8080
   - API Gateway: http://localhost:8765
   - Eureka: http://localhost:8761

---

## Notes

- All replacements were performed automatically through a PowerShell script
- The structure and logic of the application remain the same as the original
- Only the strings were changed; the functionality is identical
- The database was initialized with the new products (potions)

---

## Replacement Summary

```
Replaced strings: 8 primary replacements
  - cafeshop -> potionshop
  - cafeShop -> potionShop
  - CafeShop -> PotionShop
  - Cafe -> Potion
  - cafe -> potion
  - mina -> andrej
  - Mina -> Andrej
  - MINA -> ANDREJ

Number of cloned files: 100+
Number of directories: 40+
Project size: ~50MB (including target/ directories)
```

---

Created: 2026-04-21
Version: 1.0
Status: Cloning and replacements successfully completed
