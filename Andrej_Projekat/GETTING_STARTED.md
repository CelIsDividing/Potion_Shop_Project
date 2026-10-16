# How to Run the Andrej Project - Potion Shop

## Quick Start (5 minutes)

### Step 1: Install the Required Tools
If you do not have them installed yet:
- **Docker Desktop** - Download from https://www.docker.com/products/docker-desktop
- **Git** (optional) - https://git-scm.com/download/win

### Step 2: Prepare the Project

1. Open PowerShell as Administrator
2. Navigate to the project directory:
```powershell
cd "c:\Users\krist\Downloads\Potion_Shop_Project\Andrej_Projekat"
```

3. Set the PostgreSQL password (replace `your_password` with something secure):
```powershell
$env:DB_PASSWORD = "your_password"
```

### Step 3: Start Docker Compose

```powershell
docker-compose up -d
```

Wait about 2-3 minutes for the containers to start and the services to initialize.

### Step 4: Verify That Everything Is Running

```powershell
docker-compose ps
```

You should see the following containers with the status "Up":
```
potionshop-postgres       Up
potionshop-config-server  Up
potionshop-eureka         Up
potionshop-api-gateway    Up
potionshop-user-service   Up
potionshop-order-service  Up
potionshop-payment-service Up
potionshop-catalog-service Up
potionshop-web-app        Up
```

### Step 5: Access the Application

Open in your browser:
- **Web Application**: http://localhost:8080
- **API Gateway**: http://localhost:8765
- **Eureka Server**: http://localhost:8761
- **Config Server**: http://localhost:8888

---

## Login Details

### Test Users:

| Email | Password | Role |
|-------|---------|-------|
| ana.jovanovic@example.com | 123 | Customer |
| marko.petrovic@example.com | 123 | Customer |
| jelena.nikolic@example.com | 123 | Customer |
| admin@example.com | 123 | Admin |

---

## Available Potions to Buy

### Basic Potions:
1. **Mana Potion** (250 GOLD) - A potion that restores mana
2. **HP Potion** (300 GOLD) - A healing potion
3. **Stamina Elixir** (280 GOLD) - An energy drink
4. **Poison Vial** (400 GOLD) - A toxic vial
5. **Speed Elixir** (350 GOLD) - A speed boost

### Extras:
- Honey Extract (50 GOLD)
- Fairy Dust (100 GOLD)
- Cloud Essence (80 GOLD)
- Concentrated Essence (120 GOLD)

---

## API Examples

### 1. Login
```bash
curl -X POST http://localhost:8765/api/users/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "ana.jovanovic@example.com",
    "password": "123"
  }'
```

### 2. Search Potions
```bash
curl http://localhost:8765/api/products
```

### 3. Fetch User Profile
```bash
curl -H "Authorization: Bearer TOKEN" \
  http://localhost:8765/api/users/profile
```

### 4. Create an Order
```bash
curl -X POST http://localhost:8765/api/orders \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "items": [
      {
        "productId": 1,
        "quantity": 2,
        "extras": [1]
      }
    ]
  }'
```

---

## Monitoring

### View Service Logs

```bash
# All logs
docker-compose logs -f

# Only a specific service
docker-compose logs -f user-service
docker-compose logs -f order-service
docker-compose logs -f catalog-service

# Last 100 lines
docker-compose logs --tail=100
```

### View Database Status

```bash
docker exec potionshop-postgres psql -U postgres -d potionShop -c "SELECT * FROM products;"
```

---

## Configuration

### Change Ports

If a port is already taken, edit `docker-compose.yml`:

```yaml
# Original:
ports:
  - "5432:5432"  # PostgreSQL

# Change to:
ports:
  - "5433:5432"  # PostgreSQL on a different port
```

### Change the PostgreSQL Password

In `docker-compose.yml`:
```yaml
environment:
  POSTGRES_PASSWORD: "${DB_PASSWORD}"
```

---

## Advanced Commands

### Stop the Services

```powershell
docker-compose down
```

### Stop and Remove Everything (including the database!)

```powershell
docker-compose down -v
```

### List All Containers

```powershell
docker ps -a
```

### List All Images

```powershell
docker images
```

### Rebuild Services

```bash
docker-compose build --no-cache
docker-compose up -d
```

### Access PostgreSQL Directly

```bash
docker exec -it potionshop-postgres psql -U postgres -d potionShop
```

---

## Troubleshooting

### Problem: Containers do not start

**Solution 1: Check Docker Desktop**
- Make sure Docker Desktop is running
- Restart Docker Desktop if needed

**Solution 2: Clean and start again**
```powershell
docker-compose down -v
docker-compose pull
docker-compose up -d
```

### Problem: The port is already taken

```powershell
# Find what is using the port
netstat -ano | findstr :5432

# Kill the process
taskkill /PID PROCESS_ID /F

# Or change the port in docker-compose.yml
```

### Problem: PostgreSQL does not initialize the database

```bash
# View the logs
docker logs potionshop-postgres

# Clean and start again
docker-compose down -v
docker-compose up -d
```

### Problem: Cannot access the web application

1. Check that the application is running:
```powershell
docker ps | findstr web-app
```

2. Check the logs:
```powershell
docker logs potionshop-web-app
```

3. Check the port:
```powershell
netstat -ano | findstr :8080
```

### Problem: The API returns 401 (Unauthorized)

- Check that you are logged in
- Check that the JWT token is valid
- Try logging in again

---

## Postman Collection

### Import into Postman

1. Open Postman
2. Click **Import**
3. Select `PotionShop.postman_collection.json` from the project
4. All API calls should be available

---

## Learning and Development

### Service Structure

```
user-service/
├── src/main/java/com/example/userservice/
│   ├── controller/    # REST API controllers
│   ├── service/       # Business logic
│   ├── repository/    # Database access
│   ├── model/         # JPA entity classes
│   ├── dto/           # Data Transfer Objects
│   └── security/      # Security configuration
└── pom.xml            # Maven dependencies
```

### Add a New Feature

1. **Create a new class** in `service/`
2. **Create a REST endpoint** in `controller/`
3. **Test** through Postman or the CLI
4. **Build** and test:
```bash
cd user-service
mvn clean install
mvn spring-boot:run
```

---

## Help and Support

If you run into problems:

1. **Check the logs**: `docker-compose logs -f`
2. **Check the port**: `netstat -ano`
3. **Restart Docker**: Restart Docker Desktop
4. **Full clean**: `docker-compose down -v && docker-compose up -d`

---

## Startup Checklist

- [ ] Docker Desktop is installed and running
- [ ] Git is installed (optional)
- [ ] The project is cloned into the correct directory
- [ ] The DB_PASSWORD variable is set
- [ ] `docker-compose up -d` has been executed
- [ ] All containers are in the "Up" status
- [ ] http://localhost:8080 is accessible
- [ ] You were able to log in with a test account
- [ ] You were able to see the potions in the catalog

---

## Additional Resources

- Docker documentation: https://docs.docker.com/
- Spring Boot documentation: https://spring.io/projects/spring-boot
- PostgreSQL documentation: https://www.postgresql.org/docs/
- REST API Best Practices: https://restfulapi.net/

---

**Status**: Complete guide
**Last Updated**: 2026-04-21
**Version**: 1.0
