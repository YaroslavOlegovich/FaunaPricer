# Настройка Flutter в VS Code для сборки APK

## Проверка установки Flutter в VS Code

### 1. Откройте VS Code
### 2. Установите расширение Flutter
- Откройте Extensions (Ctrl+Shift+X)
- Найдите "Flutter" от Dart Code
- Установите расширение

### 3. Проверьте установку Flutter
- Откройте Command Palette (Ctrl+Shift+P)
- Введите "Flutter: Doctor"
- Выберите команду и посмотрите результат

## Настройка Flutter для командной строки

### Способ 1: Через VS Code

1. **Откройте Command Palette** (Ctrl+Shift+P)
2. **Введите "Flutter: New Project"**
3. **Выберите "Application"**
4. **Создайте тестовый проект** (например, "test_flutter")
5. **Откройте терминал в VS Code** (Ctrl+`)

### Способ 2: Ручная настройка PATH

1. **Найдите путь к Flutter:**
   - В VS Code откройте Command Palette
   - Введите "Flutter: Doctor"
   - Найдите строку "Flutter SDK" - там будет путь

2. **Добавьте в PATH:**
   - Откройте "Переменные среды" (Win+R → sysdm.cpl → Дополнительно → Переменные среды)
   - В "Системные переменные" найдите "Path"
   - Нажмите "Изменить" → "Создать"
   - Добавьте путь к Flutter (например: `C:\flutter\bin`)
   - Перезапустите командную строку

## Сборка APK через VS Code

### Способ 1: Через терминал VS Code

1. **Откройте терминал в VS Code** (Ctrl+`)
2. **Перейдите в папку проекта:**
   ```bash
   cd C:\FaunaPricer
   ```
3. **Установите зависимости:**
   ```bash
   flutter pub get
   ```
4. **Соберите APK:**
   ```bash
   flutter build apk --release
   ```

### Способ 2: Через Command Palette

1. **Откройте Command Palette** (Ctrl+Shift+P)
2. **Введите "Flutter: Build APK"**
3. **Выберите "Release"**

### Способ 3: Через панель Flutter

1. **Откройте панель Flutter** (иконка Flutter в боковой панели)
2. **Нажмите "Build APK"**
3. **Выберите "Release"**

## Альтернативные способы (если Flutter не работает)

### 1. Использование GitHub Actions

Создайте файл `.github/workflows/build-apk.yml`:

```yaml
name: Build APK

on:
  push:
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

### 2. Использование онлайн сервисов

- **Codemagic**: https://codemagic.io
- **Bitrise**: https://bitrise.io
- **GitHub Actions**: Автоматическая сборка при push

### 3. Попросить кого-то собрать

Если у вас есть знакомый с Flutter SDK, можете попросить его собрать APK.

## Проверка готового APK

После сборки APK будет в папке:
```
build/app/outputs/flutter-apk/app-release.apk
```

## Установка на Android

1. **Скопируйте APK** на Android устройство
2. **Включите "Установка из неизвестных источников"**
3. **Откройте APK** и установите

## Возможные проблемы

### "Flutter not found"
- Убедитесь, что Flutter установлен в VS Code
- Проверьте PATH переменную
- Перезапустите VS Code

### "Android SDK not found"
- Установите Android Studio
- Настройте Android SDK
- Добавьте ANDROID_HOME в переменные среды

### "Gradle build failed"
- Выполните `flutter clean`
- Выполните `flutter pub get`
- Попробуйте снова

## Рекомендации

1. **Для разработки**: Используйте VS Code с Flutter расширением
2. **Для сборки APK**: Настройте PATH или используйте VS Code терминал
3. **Для автоматизации**: Используйте GitHub Actions
4. **Для разового использования**: Попросите кого-то собрать APK
