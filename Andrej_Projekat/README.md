# Andrej Project - Potion Shop

Welcome to **Andrej Project**, a complete clone of the original **Online Shop** application with a new theme - **Potion Shop** (a store that sells potions for gold coins).

## Project Overview

This is a microservice architecture for an online store selling magical potions and elixirs. Customers can buy:
- **Mana Potion** - A potion that restores mana
- **HP Potion** - A healing potion
- **Stamina Elixir** - An energy drink for long journeys
- **Poison Vial** - A dangerous poison
- **Speed Elixir** - A speed boost

## What Changed

### 1. Replaced Strings
- `cafeshop` -> `potionshop`
- `cafeShop` -> `potionShop`
- `CafeShop` -> `PotionShop`
- `mina` -> `andrej`
- All references to the cafe -> Potion Store

### 2. New Products
The original cafe products were replaced with potions:

| Original | New |
|-----------|------|
| Espresso | Mana Potion |
| Cappuccino | HP Potion |
| Latte | Stamina Elixir |
| Croissant | Poison Vial |
| Chocolate cake | Speed Elixir |

### 3. New Extras
| Original | New |
|-----------|------|
| Vanilla syrup | Honey Extract |
| Almond milk | Fairy Dust |
| Whipped cream | Cloud Essence |
| Extra espresso | Concentrated Essence |

### 4. Database
- Database: `potionShop` (instead of `cafeShop`)
- All tables are kept with the same structure
- SQL data with the new products in `init-db/init.sql`

## Project Structure

```
Andrej_Projekat/
├── docker-compose.yml          # Docker Compose configuration
├── init-db/
│   └── init.sql                # Database initialization with potions
├── config-repo/                # Centralized configuration (empty)
│
├── user-service/               # User management
├── order-service/              # Order management
├── payment-service/            # Payment processing
├── catalog-service/            # Potion catalog
├── api-gateway/                # API Gateway
├── eureka-server/              # Service Discovery
├── config-server/              # Configuration Server
└── web-app/                    # Web Application
```

## Microservices

### 1. **User Service** (Port 8003)
- User management
- Authentication / Authorization
- Loyalty system (points and tiers)
- Notifications

### 2. **Catalog Service** (Port 8004)
- Management of potions and extras
- Allergen management
- Search and filtering

### 3. **Order Service** (Port 8001)
- Order management
- Adding items to an order
- Order status

### 4. **Payment Service** (Port 8002)
- Payment processing
- Card management
- Transactions

### 5. **API Gateway** (Port 8765)
- Request routing
- Authentication
- Load balancing

### 6. **Eureka Server** (Port 8761)
- Service Registry
- Service Discovery

### 7. **Config Server** (Port 8888)
- Centralized configuration
- Dynamic properties

### 8. **Web App** (Port 8080)
- Frontend application
- User interface

## Running the Project

### Prerequisites
- Docker and Docker Compose
- Java 21+
- Maven 3.8+

### Steps to Run

1. **Clone the project:**
```bash
cd Andrej_Projekat
```

2. **Prepare the environment:**
```bash
# Set the PostgreSQL password
export DB_PASSWORD=your_secure_password
```

3. **Start the containers:**
```bash
docker-compose up -d
```

4. **Access the application:**
- Web application: http://localhost:8080
- API Gateway: http://localhost:8765
- Eureka: http://localhost:8761
- Config Server: http://localhost:8888

## Test Data

### User Accounts
| Email | Password | Role |
|-------|---------|-------|
| ana.jovanovic@example.com | 123 | Customer |
| marko.petrovic@example.com | 123 | Customer |
| jelena.nikolic@example.com | 123 | Customer |
| admin@example.com | 123 | Admin |

### Payment Cards
```
User: Ana Jovanovic
Card number: 4532015112830366
Expiry: 12/26
CVV: 123

User: Marko Petrovic
Card number: 4916338506082832
Expiry: 11/25
CVV: 456

User: Jelena Nikolic
Card number: 4024007134432310
Expiry: 09/27
CVV: 789
```

## Potions to Buy

### Basic Potions
- **Mana Potion** - 250 GOLD - Effect: Magic
- **HP Potion** - 300 GOLD - Effect: Healing
- **Stamina Elixir** - 280 GOLD - Effect: Energy
- **Poison Vial** - 400 GOLD - Effect: Poison
- **Speed Elixir** - 350 GOLD - Effect: Speed

### Extras
- Honey Extract (+50 GOLD)
- Fairy Dust (+100 GOLD)
- Cloud Essence (+80 GOLD)
- Concentrated Essence (+120 GOLD)

## Loyalty System

### Tiers
- **BRONZE**: 0 points - 0% discount
- **SILVER**: 100 points - 5% discount
- **GOLD**: 500 points - 10% discount

## API Examples

### User Registration
```bash
curl -X POST http://localhost:8765/api/users/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "New User",
    "email": "user@example.com",
    "password": "password123"
  }'
```

### Search Potions
```bash
curl http://localhost:8765/api/products
```

### Create an Order
```bash
curl -X POST http://localhost:8765/api/orders \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "items": [
      {
        "productId": 1,
        "quantity": 2,
        "extras": [1, 3]
      }
    ]
  }'
```

## Postman Collection

Import `PotionShop.postman_collection.json` into Postman for all available API calls.

## Technologies

- **Backend**: Spring Boot 3.3.7
- **Java**: 21
- **Database**: PostgreSQL 16
- **Orchestration**: Docker Compose
- **Service Discovery**: Eureka
- **Config Server**: Spring Cloud Config
- **API Gateway**: Spring Cloud Gateway
- **Spring Cloud**: 2023.0.3
- **Build**: Maven
- **ORM**: Spring Data JPA
- **Security**: Spring Security + JWT
- **Frontend**: Thymeleaf (Web App)

## Troubleshooting

### Containers do not start
```bash
# Check the status
docker-compose ps

# View the logs
docker-compose logs -f

# Clean and start again
docker-compose down -v
docker-compose up -d
```

### Database is not available
```bash
# Check the connection
docker exec potionshop-postgres psql -U postgres -d potionShop -c "SELECT 1"
```

### Ports are taken
Change the ports in `docker-compose.yml` if they are already in use:
```yaml
ports:
  - "5433:5432"  # PostgreSQL on a different port
```

## Development

### Build a service
```bash
cd user-service
mvn clean install
```

### Run a service locally
```bash
mvn spring-boot:run
```

## Contributions

This project is a clone of the Online Shop project with a theme change. Feel free to add new potions, fix bugs, or improve the functionality!

## License

MIT License

---

**Note**: This is an educational project created by Andrej. All "mina" strings were replaced with "andrej" and all "cafeshop" with "potionshop".
