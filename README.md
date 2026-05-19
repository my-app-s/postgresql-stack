> [!NOTE]
> # Postgresql stack
> ![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)
> ![License](https://img.shields.io/badge/license-GNU%20AGPLv3-red.svg)
>
> 📦 **This is a recipe** for deploy container postgresql and pgAdmin as tools.

### Содержание
1. [Введение](#intro)
2. [Подробный разбор конфигурации (YAML Breakdown)](#engine)
3. [Настройка переменных (Environment Variables)](#env)
4. [Deploy](#deploy)
5. [Disclaimer](#disclaimer)
6. [License](#license)

## <a name="intro"></a>1. Введение
- Рецепт создан для упрощения развертывания postgresql c pgAdmin.

main up: `docker compose up -d`, down `docker compose down`

## <a name="engine"></a>2. Подробный разбор конфигурации

## <a name="env"></a>3. Настройка переменных

ports:
      # Если HOST_PORT_P пустая, привяжется к localhost (безопасно)
      - "${FORWARD_P:-127.0.0.1:5432}:5432"

      Итоговая шпаргалка для пользователя вашего рецепта (в .env):
Ничего не указал -> База доступна только внутри Docker-сети и локально на хосте (127.0.0.1). Безопасный стандарт.

HOST_PORT_P=0.0.0.0:5432 -> База открыта для всей локальной сети или интернета (если нужно подключиться с другого ПК).

HOST_PORT_P=127.0.0.1:12345 -> База «спрятана» на случайный порт, фактически изолирована внутри Docker для других контейнеров.

## <a name="env"></a>3. Настройка Caddy

Перед запуском создайте файл `Caddyfile` в той же директории, где находится `docker-compose.yml`.

**Вариант А: Для сервера с внешним доменом (Автоматический SSL Let's Encrypt):**

```plaintext
your-domain.com {
    reverse_proxy pgadmin:80
}
```

**Вариант Б: Для локальной или корпоративной сети (Самоподписанный SSL):**

```plaintext
192.168.1.1 {
    tls internal
    reverse_proxy pgadmin:80
}
```

> [!CAUTION]
>
> Не используйте флаг -v при очистке:
> Если вы выполните команду остановки вот так: docker compose down -v (с флагом -v или --volumes), Docker удалит и контейнеры, и уничтожит все ваши волумы вместе с базой данных. Используйте эту команду только в том случае, если хотите намеренно сбросить проект до заводских настроек.
>
> Не меняйте имена волумов без необходимости:
> Если вы переименуете postgres_data_volume в postgres_super_data, Docker при запуске создаст абсолютно новый, пустой волум, а старый останется лежать в системе сиротой.

## <a name="deploy"></a>4. Deploy

Up stack as default without service pgAdmin, only base service postgresql.

```bash
# up stack as default
docker compose up -d
# down stack as default
docker compose down
```

Up stack as default with service pgAdmin.

> [!IMPORTANT]
> Access pgAdmin by host ip:host port example:'192.168.100.1:9080'

```bash
# up stack with service pgAdmin
docker docker compose --profile tools up -d
# down stack with service pgAdmin
docker compose --profile tools down
```

up with pgAdmin: `docker compose --profile tools up -d`(down: `docker compose --profile tools down`")

## <a name="disclamer"></a>5. ⚠️ Disclaimer / Отказ от ответственности

**English**: Materials are provided ***"as is"*** under the LICENSE file. No warranties, no rights granted unless explicitly stated. Authors are not liable for damages. No partnership or obligations created.  

**Русский**: Материалы предоставляются ***"как есть"*** и регулируются LICENSE. Гарантий нет, права не передаются без явного указания. Автор(ы) не несут ответственности. Партнёрство или обязательства не создаются.  

📌 See full disclaimer in [DISCLAIMER.md](https://github.com/my-app-s/my-app-s/blob/main/DISCLAIMER.md)
