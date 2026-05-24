> [!NOTE]
> # Postgresql stack
> ![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)
> ![License](https://img.shields.io/badge/license-GNU%20AGPLv3-red.svg)
>
> 📦 **This is a recipe** for deploy container postgresql and pgAdmin as tools.

## Введение
- Рецепт создан для упрощения развертывания postgresql c pgAdmin с возможностью поджключения к сети docker управляемой маршрутизацией **traefik**.
- возможное использование локальное или через маршрутизацию **traefik**
    - для локального использование в переменную `TRAEFIK_NETWORK_NAME` указывать не нужно, бедет использовано по умолчанию название ***db_stack_network*** с параметром ***external*** с значением **false**, значение **false** необхоимо для режима разработки или локального использования докер сам создаст сеть с дефолтным именем
        - выставив для ***external*** значение **true** докер сам сеть создовать не будет так подрозумевается что сеть **traefik** к примеру ***traefik_public_network*** уже создана с контейнером **traefik**
    - для использования маршрутизации **traefik** необходимо в переменной `TRAEFIK_NETWORK_NAME` задать назвние сети из контейнера с **traefik** и задать для ***external*** значение **true** так сеть не будет создаваться докером и будет использоваться заданная сеть

## Настройка переменных окружения

- в репозитории находится шаблон .env.example файла, если это необходимо создайте копию этого файла с названием .env рядом с docker compose файлом
    - к примеру на linux для этого выполните комманду `cp .env.exapmle .env` находясь в скачаном репозитории
- для работы переменных не обходимо расскоментировать нужные

#### В данном шаблоне находятся следующие переменные:

> **Примечание**: возможно задать нужные параметры

- `VERSION_P` версия образа для PostgreSQL
- `VERSION_PG` версия образа для pgAdmin

> **Примечание**: Возможность указывать кастомные сборки сознательно исключена. Проект ориентирован исключительно на использование актуальных официальных образов в целях безопасности и стабильности.

- `HOST_PORT_P` порт хоста для PostgreSQL
- `VERSIHOST_PORT_PGON_P` порт хоста для pgAdmin

> [!IMPORTANT]
> для безопасности в файле override блок для порта pgadmin закоментированы так как он необходим если не используется маршрутизация **traefik**

- `TRAEFIK_ENABLED` булевое значение для включения **traefik**
- `DOMAIN` имя domain, или будет использовано значение по умолчанию ***localhost***
- `CERT_RESOLVER` указывает имя обработчика сертефикатов, если значение не задать то по умолчанию будет пустое **traefik** создаст локальный самоподписаный сертификат
- `TRAEFIK_NETWORK_NAME` имя сети **traefik**
- `TRAEFIK_NETWORK_EXTERNAL` булевое значение для выбора режима работы сети то есть докер создаст сеть локальную или подключится к уже созданной сети **traefik**

## Настройка переменных окружения

### Файл .env.example

В репозитории находится шаблон файла `.env.example`. Для настройки конфигурации создайте его копию с именем `.env` в той же директории, где находится файл `docker-compose.yml`.

- К примеру, в Linux для этого выполните команду:
  ```bash
  cp .env.example .env
  ```

- Чтобы активировать нужную переменную, раскомментируйте её (уберите символ `#` в начале строки) и задайте необходимое значение. По умолчанию стек уже преднастроен для локальной разработки.

---

### Описание доступных переменных

#### Версии образов (Container Image Versions)

> **Примечание**: Возможность указывать кастомные сборки сознательно исключена. Проект ориентирован исключительно на использование актуальных официальных образов в целях безопасности и стабильности. Если переменные закомментированы, Docker по умолчанию загрузит тег `latest`.

* `VERSION_P` — версия официального образа для PostgreSQL (например, `16-alpine`).
* `VERSION_PG` — версия официального образа для pgAdmin (например, `8.5`).

#### Локальные порты хоста (Local Service Ports)

* `HOST_PORT_P` — порт хоста для доступа к PostgreSQL (по умолчанию `5432`). Измените, если этот порт уже занят на сервере.
* `HOST_PORT_PG` — порт хоста для прямого доступа к pgAdmin (по умолчанию `8080`).

> [!IMPORTANT]
> Для обеспечения безопасности в файле `docker-compose.override.yml` блок портов для pgAdmin по умолчанию закомментирован. Прямая публикация порта требуется только в том случае, если вы **не используете** маршрутизацию через Traefik.

#### Настройка Production и Reverse Proxy (Traefik)

* `TRAEFIK_ENABLED` — булевое значение (`true`/`false`) для включения маршрутизации через Traefik. Если указано `false`, доступ к сервисам настраивается через порты в `override`-файле.
* `DOMAIN` — ваше доменное имя (должно указывать на IP-адрес сервера). Если оставить пустым, будет использовано значение по умолчанию — `localhost`.
* `CERT_RESOLVER` — имя резолвера (обработчика) SSL-сертификатов, настроенного в вашем Traefik (например, `myresolver`). Если значение не задано, Traefik создаст локальный самоподписанный сертификат для тестирования.
* `TRAEFIK_NETWORK_NAME` — имя Docker-сети, которую Traefik использует для маршрутизации трафика.
* `TRAEFIK_NETWORK_EXTERNAL` — булевое значение (`true`/`false`), определяющее режим работы сети. Укажите `true`, если сеть Traefik уже создана в системе внешним образом (вне этого стека). Если `false`, Docker Compose создаст локальную сеть автоматически.

## Deploy

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

> [!CAUTION]
>
> Не используйте флаг -v при очистке:
> Если вы выполните команду остановки вот так: docker compose down -v (с флагом -v или --volumes), Docker удалит и контейнеры, и уничтожит все ваши волумы вместе с базой данных. Используйте эту команду только в том случае, если хотите намеренно сбросить проект до заводских настроек.
>
> Не меняйте имена волумов без необходимости:
> Если вы переименуете postgres_data_volume в postgres_super_data, Docker при запуске создаст абсолютно новый, пустой волум, а старый останется в системе.

## 📜 Disclaimer

**English**: Materials are provided ***as is*** under the LICENSE file. No warranties, no rights granted unless explicitly stated. Authors are not liable for damages. No partnership or obligations created.  

**Русский**: Материалы предоставляются ***как есть*** и регулируются LICENSE. Гарантий нет, права не передаются без явного указания. Автор(ы) не несут ответственности. Партнёрство или обязательства не создаются.  

📌 See full disclaimer in [DISCLAIMER.md](https://github.com/my-app-s/my-app-s/blob/main/DISCLAIMER.md)

---

## 📜 Лицензия

Проект лицензирован под **GNU Affero General Public License v3.0 (AGPLv3)**.
См. [LICENSE](./LICENSE) для подробностей.
