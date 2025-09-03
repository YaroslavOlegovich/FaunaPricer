# Инструкция по сборке APK для FaunaPricer

## Предварительные требования

1. **Установленный Flutter SDK** (версия 3.0+)
2. **Android SDK** (через Android Studio или отдельно)
3. **Java Development Kit (JDK)** версии 8 или выше

## Пошаговая инструкция

### 1. Подготовка окружения

Убедитесь, что Flutter настроен корректно:

```bash
flutter doctor
```

Все компоненты должны быть отмечены как готовые (зелёные галочки).

### 2. Настройка Android SDK

Если Android SDK не настроен, установите Android Studio и настройте SDK:

1. Скачайте Android Studio: https://developer.android.com/studio
2. Установите Android SDK (API Level 21+)
3. Настройте переменные окружения:
   - `ANDROID_HOME` - путь к Android SDK
   - Добавьте в PATH: `%ANDROID_HOME%\tools` и `%ANDROID_HOME%\platform-tools`

### 3. Обновление зависимостей

В папке проекта выполните:

```bash
flutter pub get
```

### 4. Сборка APK

#### Debug APK (для тестирования):
```bash
flutter build apk --debug
```

#### Release APK (для распространения):
```bash
flutter build apk --release
```

### 5. Поиск готового APK

После сборки APK файл будет находиться в:
- **Debug**: `build/app/outputs/flutter-apk/app-debug.apk`
- **Release**: `build/app/outputs/flutter-apk/app-release.apk`

## Альтернативные способы сборки

### Сборка для конкретной архитектуры:

```bash
# Только для ARM64 (современные устройства)
flutter build apk --target-platform android-arm64

# Только для ARM32 (старые устройства)
flutter build apk --target-platform android-arm

# Универсальный APK (все архитектуры)
flutter build apk --split-per-abi
```

### Сборка App Bundle (рекомендуется для Google Play):

```bash
flutter build appbundle --release
```

## Установка APK на устройство

### Через ADB (Android Debug Bridge):

1. Включите "Отладку по USB" на Android устройстве
2. Подключите устройство к компьютеру
3. Выполните команду:

```bash
flutter install
```

### Ручная установка:

1. Скопируйте APK файл на устройство
2. Включите "Установка из неизвестных источников" в настройках
3. Откройте APK файл и установите

## Возможные проблемы и решения

### Ошибка "Gradle build failed":
```bash
flutter clean
flutter pub get
flutter build apk --release
```

### Ошибка "SDK location not found":
Проверьте файл `android/local.properties` и укажите правильный путь к Flutter SDK.

### Ошибка "Android SDK not found":
Убедитесь, что Android SDK установлен и переменная `ANDROID_HOME` настроена.

### Ошибка "Java version":
Убедитесь, что используется JDK 8 или выше.

## Оптимизация APK

### Уменьшение размера:

1. **Использование ProGuard** (добавить в `android/app/build.gradle`):
```gradle
buildTypes {
    release {
        minifyEnabled true
        proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
    }
}
```

2. **Удаление неиспользуемых ресурсов**:
```bash
flutter build apk --release --obfuscate --split-debug-info=debug-info
```

## Проверка APK

После сборки можно проверить APK:

```bash
# Информация об APK
flutter build apk --analyze-size

# Проверка подписи
jarsigner -verify -verbose -certs app-release.apk
```

## Готовый APK

После успешной сборки у вас будет готовый APK файл, который можно:
- Установить на Android устройства
- Распространять через файлообменники
- Загрузить в Google Play Store (после дополнительной настройки)

Размер APK обычно составляет 15-25 МБ для release версии.
