# Сборка APK без установки Flutter SDK

Если у вас нет возможности установить Flutter SDK, есть несколько альтернативных способов получить APK:

## Способ 1: Онлайн сборка (GitHub Actions)

### 1. Создайте GitHub репозиторий

1. Зайдите на https://github.com
2. Создайте новый репозиторий "FaunaPricer"
3. Загрузите все файлы проекта

### 2. Настройте автоматическую сборку

Создайте файл `.github/workflows/build-apk.yml`:

```yaml
name: Build APK

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
        channel: 'stable'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Build APK
      run: flutter build apk --release
    
    - name: Upload APK
      uses: actions/upload-artifact@v3
      with:
        name: fauna-pricer-apk
        path: build/app/outputs/flutter-apk/app-release.apk
```

### 3. Получите APK

После push кода в репозиторий:
1. Перейдите в раздел "Actions"
2. Дождитесь завершения сборки
3. Скачайте APK из артефактов

## Способ 2: Использование онлайн IDE

### DartPad (ограниченная функциональность)

1. Зайдите на https://dartpad.dev
2. Скопируйте код из `lib/main.dart`
3. Запустите в браузере (без графиков)

### CodePen / JSFiddle

Можно адаптировать код для веб-версии с использованием JavaScript.

## Способ 3: Готовый APK

Если у вас есть доступ к компьютеру с Flutter, можно:

1. Скачать проект
2. Установить Flutter SDK
3. Выполнить команды:
   ```bash
   flutter pub get
   flutter build apk --release
   ```

## Способ 4: Использование Docker

Если у вас установлен Docker:

### 1. Создайте Dockerfile:

```dockerfile
FROM ubuntu:20.04

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-8-jdk

# Установка Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:${PATH}"

# Установка Android SDK
RUN mkdir -p /android-sdk
ENV ANDROID_HOME=/android-sdk
ENV PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:${PATH}"

RUN curl -o sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && \
    unzip sdk-tools.zip -d /android-sdk && \
    rm sdk-tools.zip

RUN yes | sdkmanager --licenses
RUN sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"

WORKDIR /app
COPY . .

RUN flutter pub get
RUN flutter build apk --release

CMD ["cp", "build/app/outputs/flutter-apk/app-release.apk", "/output/"]
```

### 2. Соберите и запустите:

```bash
docker build -t fauna-pricer .
docker run -v $(pwd):/output fauna-pricer
```

## Способ 5: Использование облачных сервисов

### Codemagic

1. Зайдите на https://codemagic.io
2. Подключите GitHub репозиторий
3. Настройте автоматическую сборку
4. Получите APK после сборки

### Bitrise

1. Зайдите на https://bitrise.io
2. Подключите репозиторий
3. Используйте готовый workflow для Flutter
4. Скачайте готовый APK

## Рекомендации

1. **Для разового использования**: Используйте GitHub Actions
2. **Для регулярных сборок**: Настройте CI/CD
3. **Для разработки**: Установите Flutter SDK локально
4. **Для демонстрации**: Используйте веб-версию

## Размер APK

Ожидаемый размер готового APK:
- **Debug**: ~50-80 МБ
- **Release**: ~15-25 МБ
- **Split APK**: ~8-12 МБ на архитектуру

## Безопасность

При использовании онлайн сервисов:
- Не загружайте конфиденциальные данные
- Проверяйте репутацию сервиса
- Используйте официальные источники
