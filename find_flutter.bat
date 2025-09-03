@echo off
echo ========================================
echo    Поиск Flutter SDK
echo ========================================
echo.

echo Ищем Flutter в стандартных местах...
echo.

REM Проверяем C:\flutter
if exist "C:\flutter\bin\flutter.bat" (
    echo НАЙДЕН: C:\flutter\bin\flutter.bat
    echo.
    echo Для добавления в PATH выполните:
    echo setx PATH "%%PATH%%;C:\flutter\bin"
    echo.
    goto :found
)

REM Проверяем C:\src\flutter
if exist "C:\src\flutter\bin\flutter.bat" (
    echo НАЙДЕН: C:\src\flutter\bin\flutter.bat
    echo.
    echo Для добавления в PATH выполните:
    echo setx PATH "%%PATH%%;C:\src\flutter\bin"
    echo.
    goto :found
)

REM Проверяем в папке пользователя
if exist "%USERPROFILE%\flutter\bin\flutter.bat" (
    echo НАЙДЕН: %USERPROFILE%\flutter\bin\flutter.bat
    echo.
    echo Для добавления в PATH выполните:
    echo setx PATH "%%PATH%%;%USERPROFILE%\flutter\bin"
    echo.
    goto :found
)

REM Проверяем в AppData
if exist "%LOCALAPPDATA%\flutter\bin\flutter.bat" (
    echo НАЙДЕН: %LOCALAPPDATA%\flutter\bin\flutter.bat
    echo.
    echo Для добавления в PATH выполните:
    echo setx PATH "%%PATH%%;%LOCALAPPDATA%\flutter\bin"
    echo.
    goto :found
)

REM Ищем в Program Files
for /d %%i in ("C:\Program Files\*flutter*") do (
    if exist "%%i\bin\flutter.bat" (
        echo НАЙДЕН: %%i\bin\flutter.bat
        echo.
        echo Для добавления в PATH выполните:
        echo setx PATH "%%PATH%%;%%i\bin"
        echo.
        goto :found
    )
)

REM Ищем в Program Files (x86)
for /d %%i in ("C:\Program Files (x86)\*flutter*") do (
    if exist "%%i\bin\flutter.bat" (
        echo НАЙДЕН: %%i\bin\flutter.bat
        echo.
        echo Для добавления в PATH выполните:
        echo setx PATH "%%PATH%%;%%i\bin"
        echo.
        goto :found
    )
)

echo Flutter не найден в стандартных местах.
echo.
echo Возможные решения:
echo 1. Установите Flutter SDK с https://flutter.dev/docs/get-started/install
echo 2. Или используйте GitHub Actions для сборки APK
echo 3. См. VSCODE_FLUTTER_SETUP.md для настройки VS Code
echo.
goto :end

:found
echo ========================================
echo    Flutter найден!
echo ========================================
echo.
echo Теперь можно:
echo 1. Добавить в PATH (команда выше)
echo 2. Перезапустить командную строку
echo 3. Запустить build_apk.bat
echo.

:end
pause
