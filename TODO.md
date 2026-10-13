# Обновление Terraform providers

## Цель и границы

Обновить `hashicorp/google`, `hashicorp/google-beta`, `hashicorp/kubernetes`, `hashicorp/null` и `hashicorp/random` до последних стабильных релизов, проверенных на дату выбора целевых версий. Для root entry modules закрепить точные версии; для дочерних модулей задать совместимые диапазоны `~> MAJOR.MINOR` с обоснованной нижней границей.

`google-beta` входит в задачу: он уже объявлен рядом с `google` и явно используется в Cloud SQL. Другие провайдеры и обновление Terraform runtime не входят в задачу без выявленной необходимости и согласования расширения объёма.

Сейчас выполняется подготовка плана и правил репозитория. Последние релизы и совместимость ещё не проверены; примеры `8.3.5` и `~> 8.0` не являются выбранными версиями. Изменения инфраструктуры не выполняются.

## Исходные факты — 2026-10-13

Это статическая инвентаризация объявлений в исходниках, а не подтверждение реально установленных версий в окружениях потребителей. Количество означает число объявлений `required_providers`, а не число ресурсов.

| Provider | Точные pins | Другие ограничения | Без version |
| --- | --- | --- | --- |
| `google` | `6.40.0` — 39 | `< 7.0.0` — 4; `>= 6.31, < 7` — 1 | 4 |
| `google-beta` | `6.40.0` — 35 | `< 7.0.0` — 4; `>= 6.31, < 7` — 1 | 4 |
| `kubernetes` | `2.38.0` — 5 | — | 4 |
| `null` | `3.2.3` — 28 | `~> 3.1` — 1 | 3 |
| `random` | `3.6.3` — 30 | `~> 3.1` — 1 | 4 |

Важные пути и особенности:

- `modules/gcp/versions.tf` и `modules/k8s/versions.tf`: точные pins верхнеуровневых модулей повторяются в большинстве дочерних модулей.
- `modules/gcp/iam/{versions.tf,custom_role/versions.tf,role/versions.tf,service_account/versions.tf}`: ограничения Google и Google Beta `< 7.0.0`; они блокируют переход на следующий major во всём связанном графе.
- `modules/gcp/cloudsql/postgresql/versions.tf`: Google/Google Beta `>= 6.31, < 7`, Null/Random `~> 3.1`; сохранены upstream license и `provider_meta`.
- `modules/rod/cloud/gcp/{versions.tf,internal/versions.tf,product/versions.tf}`, `modules/rod/k8s/{versions.tf,internal/versions.tf,product/versions.tf}` и `modules/secrets/versions.tf`: есть объявления целевых провайдеров без ограничения версии.
- `random_password` используется в `modules/postgres/roles/main.tf`, `random_string` — в `modules/mongodb_atlas/database_user/main.tf`, `random_id` — в `modules/rod/cloud/gcp/gcp_iam_variables.tf`. В PostgreSQL roles и MongoDB database_user нет явного объявления Random; проверить неявное разрешение зависимости.
- Статический поиск обнаружил 82 различных типа resources/data sources: 70 `google_*`, 8 `kubernetes_*`, `null_resource`, `random_id`, `random_password`, `random_string`. Полный перечень с аргументами предстоит оформить на этапе анализа влияния.
- В корне репозитория нет `.tf`; `modules/gcp` и `modules/k8s` — входные модули библиотеки, а не самостоятельные deployment roots с backend/state. Некоторые wrappers `rod` содержат provider configurations.
- Локальный Terraform — `1.9.5`; CI toolchain в `MODULE.bazel` — `1.14.4`; Bazel — `8.1.0`. В модулях встречаются floors `>= 0.13`, `>= 1.3`, `>= 1.8`; фактическую поддержку надо проверить.
- `.terraform.lock.hcl` игнорируется; отслеживаемых lock-файлов не найдено. Backend и критичность окружений потребителей пока не установлены.
- PR CI выполняет `bazel test //...`; `tf_test` включает fmt и validate с `backend = False`. Pre-commit запускает только `terraform_fmt`.

## Правило версий

- Предварительно считаем `modules/gcp` и `modules/k8s` root entry modules библиотеки: точный pin каждого используемого целевого provider.
- В их дочерних модулях используем совместимые диапазоны. Например, `~> 8.0` означает `>= 8.0, < 9.0`; `~> 8.0.0` означает только `8.0.x`.
- Если модуль использует возможность, добавленную позднее, нижняя граница должна отражать эту версию: нельзя заявлять поддержку всего major без проверки.
- Для `rod`, `secrets` и других цепочек сначала определяем роль по call graph. Переиспользуемые wrappers получают диапазоны; самостоятельные root entrypoints — точный pin. Не добавляем искусственный `versions.tf` в корень репозитория.
- Операционные roots в consuming repositories должны закреплять точную версию и свой lock-файл. Обновление этих репозиториев оформляется отдельным согласованным изменением.
- Все ограничения одного provider source должны пересекаться; aliases не дают возможности установить разные версии одного провайдера в одном root.

## Вехи и checklist

### M0 — Правила и план

- [x] Изучить структуру и пример `../helm-charts/AGENTS.md`.
- [x] Проверить существующие рекомендации `README.md`, `GEMINI.md`, CI и Bazel.
- [x] Создать базовый `AGENTS.md`, адаптированный к Terraform-модулям.
- [x] Записать исходные ограничения и подготовить этот checklist.

Результат: правила работы и последовательность обновления доступны в репозитории.

### M1 — Полная инвентаризация и baseline

- [x] Собрать текущие явные pins, диапазоны и объявления без версии.
- [x] Проверить локальный runtime, toolchain CI и текущую политику lock-файлов.
- [ ] Построить call graph: entry modules, дочерние модули, standalone wrappers, sources и provider mappings/aliases.
- [ ] Зафиксировать окончательную таблицу `module → role → source → constraint → provider configuration`.
- [ ] Найти неявные зависимости и отсутствующие `required_providers`, включая Random в PostgreSQL/MongoDB.
- [ ] Определить representative consumers/fixtures, реальные выбранные версии из их lock-файлов и способ запуска: local, CI или другое.
- [ ] Зафиксировать backend, окружения и критичность для планов; credentials и state не добавлять в репозиторий.
- [ ] Запустить baseline fmt/validate/Bazel на CI runtime до изменений; отдельно записать уже существующие ошибки.

Критерий завершения: понятны все графы зависимостей, места точных pins и baseline проверки. Доступ к consumers, если отсутствует, отмечен как конкретный пробел.

### M2 — Последние стабильные релизы

- [ ] Проверить официальные Terraform Registry страницы Google, Google Beta, Kubernetes, Null и Random.
- [ ] Сверить версии с релизами официальных provider repositories; исключить prerelease/RC.
- [ ] Записать таблицу `provider → исходная версия → latest stable → дата релиза → дата проверки → ссылки`.
- [ ] Проверить минимальный Terraform runtime, требования к Kubernetes/API/auth и поддержку платформ CI/разработчиков.
- [ ] Выбрать совместимые целевые версии Google/Google Beta и заморозить targets для этого обновления.

Критерий завершения: у каждого target есть официальный источник; `latest` относится к конкретной дате проверки. Если latest требует расширения задачи, причина явно зафиксирована.

### M3 — Изменения от baseline до targets

- [ ] Прочитать official upgrade guides для каждого пересекаемого major и все промежуточные release notes.
- [ ] Отдельно проверить Google и Google Beta: их schemas и изменения могут различаться.
- [ ] Собрать breaking changes, удаления/deprecations аргументов и ресурсов, изменения типов, defaults и validation.
- [ ] Отметить изменения auth, diff/refresh, import IDs, timeouts, ForceNew/replacement и state migrations.
- [ ] Проверить поведение существующих `random_*`, `keepers`, паролей и `null_resource` triggers/provisioners.
- [ ] Составить реестр `изменение → версия → официальный источник → возможное последствие → проверка`.

Критерий завершения: учтён весь интервал обновления, включая промежуточные major; отсутствие влияния также должно иметь основание.

### M4 — Влияние на наши ресурсы

- [ ] Составить полный перечень resources/data sources, используемых аргументов и nested blocks с путями и provider mappings.
- [ ] Сопоставить каждое изменение M3 с реальным использованием; сравнить schemas baseline/targets через `terraform providers schema -json` в изолированных fixtures.
- [ ] Приоритетно разобрать GKE cluster/node pools, Cloud SQL/replicas, IAM, Cloud Run, storage/network и остальные реально затронутые типы.
- [ ] Проверить 8 используемых Kubernetes resource types: поддержка текущих имен и `_v1`, schemas, metadata, secrets, RBAC и service accounts. Не переименовывать ресурсы автоматически ради стиля.
- [ ] Проверить Random вне GCP, зависимые secrets/outputs и риск неожиданной ротации credentials.
- [ ] Проверить влияние новых defaults и computed attributes на outputs и потребителей `rod`.
- [ ] Для каждого изменения записать `change → module/file/resource/attribute → impact → migration → validation`.
- [ ] Классифицировать последствия: без изменений / правка HCL / изменение поведения / replacement или state migration.
- [ ] Определить поддержку ранних minor в child ranges и план возврата с учётом state schema.

Критерий завершения: есть матрица влияния и конкретный объём необходимых правок; новые версии выбираются с пониманием provider upgrade risk, identity churn, CI drift и state compatibility.

### M5 — Обновление кода

- [ ] Обновить exact pins в определённых M1 root entry modules и согласовать ranges всех дочерних модулей.
- [ ] Устранить блокирующие старые upper bounds в IAM/Cloud SQL и несовместимые constraints в wrappers.
- [ ] Добавить необходимые явные зависимости там, где подтверждено неявное использование целевых providers.
- [ ] Сделать только необходимые изменения schemas/аргументов из M4; сохранить addresses и интерфейсы, где возможно.
- [ ] Если адрес или тип ресурса всё-таки меняется, оформить и проверить отдельную migration procedure; не предполагать, что смена типа безопасна для state.
- [ ] Решить lock policy для deployment roots/fixtures; сохранить текущую `.gitignore` без случайных force-add.
- [ ] Обновить README/migration notes и затронутые `CHANGELOG_*.md`/общий changelog по схеме релизов репозитория.

Критерий завершения: constraints совместимы во всём графе, а diff содержит только provider upgrade и обусловленные им изменения.

### M6 — Проверка совместимости

- [ ] Запустить fmt, init без backend и validate для затронутых child modules и representative compositions на Terraform CI toolchain.
- [ ] Выполнить `bazel test //...`; подтвердить, какие graphs действительно покрыты, и проверить оставшиеся отдельными fixtures.
- [ ] Для заявленных ranges проверить нижнюю границу и выбранный target; сузить range, если нижняя граница не проходит.
- [ ] Добавить точечные regression checks для подтверждённых рисков M4, без тестов ради дублирования HCL.
- [ ] В доступных non-production consumers получить baseline и candidate plans с одинаковыми inputs/runtime/backend и минимальным временным разрывом.
- [ ] Сравнить изменения resource actions, outputs, sensitive values и rotation/replacement; объяснить каждое неожиданное изменение.
- [ ] Если нужны state upgrades, предусмотреть проверку на безопасной копии/тестовом окружении и проверить применимость rollback; план сам по себе не доказывает успешный apply.
- [ ] Зафиксировать результаты и недоступные проверки. Сохранённые plans/state не публиковать и не коммитить.

Критерий завершения: проверки проходят; нет необъяснённых replace/destroy/rotation. Отсутствие доступа к live state явно ограничивает вывод о production compatibility.

### M7 — Подготовка выпуска и отдельный rollout

- [ ] Подготовить review summary: версии, scope, матрица влияния, результаты проверок, migration/rollback notes.
- [ ] Проверить diff и связанные release entries; подготовить commit/PR, если пользователь запросит.
- [ ] Для отдельно авторизованного rollout начать с non-production и только после оценки результата переходить к production.
- [ ] Перед apply сохранить baseline pins/lock и доступную backend recovery point; подтвердить поддержку предыдущим provider обновлённой schema state.
- [ ] Применять только просмотренный plan artifact после разрешения на конкретное окружение и операцию.
- [ ] После авторизованного rollout проверить повторный plan и отсутствие неожиданного drift/rotation.

Критерий завершения обновления библиотеки: M1–M6 выполнены, release notes и review summary готовы. Rollout в consumers имеет отдельный статус и требует доступа и авторизации; подготовка плана его не разрешает.

## Команды проверки на этапе реализации

Пути ниже — примеры существующих entry modules, не полный список покрытия. Выполнять после baseline и выбора targets; сейчас эти проверки не заявляются как выполненные.

```bash
git status --short
terraform version
terraform fmt -check -recursive modules/gcp
terraform fmt -check -recursive modules/k8s
terraform -chdir=/tmp/provider-upgrade-fixture init -upgrade -backend=false
terraform -chdir=/tmp/provider-upgrade-fixture validate
terraform -chdir=/tmp/provider-upgrade-fixture providers schema -json
bazel test //...
pre-commit run --files <changed-tf-files>
git diff --check
```

Для baseline fixture использовать исходные pins и `init -backend=false`; baseline и candidate держать раздельно. Fixtures нужны для каждого проверяемого графа, включая модули с required inputs и provider configurations.

В реальном consumer, после определения окружения и разрешённого доступа:

```bash
terraform -chdir=<consumer-root> plan -out=<protected-plan-path>
terraform -chdir=<consumer-root> show -json <protected-plan-path>
```

Plan и его JSON могут содержать secrets. Путь должен быть защищённым и вне Git; не выводить весь JSON в общедоступные логи. При отсутствии доступа завершать статическую проверку, а live plan обозначать как невыполненную обязательную проверку перед rollout.
