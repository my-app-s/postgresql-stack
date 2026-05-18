# Универсальный Docker Compose (локально / с Traefik через .env)

## Принцип

Поведение определяется **только `.env`**:
- без `.env` → локальный запуск
- с `.env` → интеграция с Traefik

---

## Режимы работы

### 1. Локальный запуск (по умолчанию)

Условия:
- `.env` отсутствует или пустой

Поведение:
- создается локальная сеть
- Traefik отключен (`traefik.enable=false`)
- доступ через localhost

Результат:
```

[http://localhost](http://localhost):<PORT>

```

---

### 2. Продакшен (с Traefik)

Пример `.env`:

```env
DOMAIN=my-site.ddns.net
CERT_RESOLVER=le

# локальный доступ (опционально)
LOCAL_PORT=8080

# Traefik
TRAEFIK_ENABLED=true
TRAEFIK_NETWORK_EXTERNAL=true
TRAEFIK_NETWORK_NAME=traefik_public_network
```

Поведение:

* используется внешняя сеть Traefik
* Traefik видит контейнеры
* создаются router + TLS
* доступ по HTTPS

Результат:

```
https://<DOMAIN>
```

---

## docker-compose.yml

```yaml
services:
  postgres:
    image: postgres:${VERSION:-latest}
    container_name: postgres

    restart: unless-stopped

    environment:
      POSTGRES_PASSWORD: secret
      POSTGRES_USER: postgres
      POSTGRES_DB: practice
      TZ: UTC

    volumes:
      - postgres_data_volume:/var/lib/postgresql

    labels:
      - "traefik.enable=${TRAEFIK_ENABLED:-false}"

      - "traefik.http.routers.postgres.rule=Host(`${DOMAIN:-localhost}`)"
      - "traefik.http.routers.postgres.entrypoints=websecure"

      - "traefik.http.services.postgres.loadbalancer.server.port=${HOST_PORT_P:-5432}"

      - "traefik.http.routers.postgres.tls=true"
      - "traefik.http.routers.postgres.tls.certresolver=${CERT_RESOLVER:-}"

    networks:
      - network_stack

  pgadmin:
    image: dpage/pgadmin4:latest
    container_name: pgadmin

    restart: unless-stopped

    profiles:
      - tools

    environment:
      PGADMIN_DEFAULT_EMAIL: admin@mail.com
      PGADMIN_DEFAULT_PASSWORD: admin
      TZ: UTC

    volumes:
      - pgadmin_data_volume:/var/lib/pgadmin

    depends_on:
      - postgres

    labels:
      - "traefik.enable=${TRAEFIK_ENABLED:-false}"

      - "traefik.http.routers.pgadmin.rule=Host(`${DOMAIN:-localhost}`)"
      - "traefik.http.routers.pgadmin.entrypoints=websecure"

      - "traefik.http.services.pgadmin.loadbalancer.server.port=${HOST_PORT_PG:-80}"

      - "traefik.http.routers.pgadmin.tls=true"
      - "traefik.http.routers.pgadmin.tls.certresolver=${CERT_RESOLVER:-}"

    networks:
      - network_stack

volumes:
  postgres_data_volume:
  pgadmin_data_volume:

networks:
  network_stack:
    name: ${TRAEFIK_NETWORK_NAME:-postgres_network}
    external: ${TRAEFIK_NETWORK_EXTERNAL:-false}
```

---

## Переменные

| Переменная               | Значение                  |
| ------------------------ | ------------------------- |
| DOMAIN                   | домен для Traefik         |
| CERT_RESOLVER            | ACME resolver             |
| TRAEFIK_ENABLED          | включает Traefik          |
| TRAEFIK_NETWORK_NAME     | имя сети Traefik          |
| TRAEFIK_NETWORK_EXTERNAL | использовать внешнюю сеть |
| HOST_PORT_P              | порт postgres             |
| HOST_PORT_PG             | порт pgadmin              |

---

## Логика сети

```yaml
name: ${TRAEFIK_NETWORK_NAME:-postgres_network}
external: ${TRAEFIK_NETWORK_EXTERNAL:-false}
```

* `external=false` → создается локальная сеть
* `external=true` → подключение к существующей сети Traefik

---

## Логика Traefik

```yaml
traefik.enable=${TRAEFIK_ENABLED:-false}
```

* `false` → контейнер игнорируется
* `true` → создается router/service

---

## TLS

```yaml
tls=true
certresolver=${CERT_RESOLVER}
```

* resolver задан → Let's Encrypt
* resolver пуст → self-signed

---

## Особенности

* один compose → два режима работы
* не требует изменений файла
* управляется через `.env`
* совместим с локальной разработкой и продакшеном

---

## Итог

* локально: изолированная среда
* прод: автоматический HTTPS + маршрутизация
* переключение режимов без изменения compose
