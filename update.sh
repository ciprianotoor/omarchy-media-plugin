#!/usr/bin/env bash

set -Eeuo pipefail

PLUGIN_ID="io.github.ciprianotoor.omarchy-media"
EXPECTED_REMOTE="git@github.com:ciprianotoor/omarchy-media-plugin.git"
REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -d "$REPO_DIR/.git" ]]; then
    printf 'Error: este directorio no es un repositorio Git.\n' >&2
    exit 1
fi

command -v git >/dev/null 2>&1 || {
    printf 'Error: git no está instalado.\n' >&2
    exit 1
}

cd "$REPO_DIR"
remote=$(git remote get-url origin 2>/dev/null || true)
case "$remote" in
    "$EXPECTED_REMOTE"|https://github.com/ciprianotoor/omarchy-media-plugin.git) ;;
    *)
        printf 'Error: el remoto origin no coincide con el plugin esperado:\n%s\n' "$remote" >&2
        exit 1
        ;;
esac

if ! git diff --quiet || ! git diff --cached --quiet; then
    printf 'Error: hay cambios locales sin guardar. Revisa git status antes de actualizar.\n' >&2
    exit 1
fi

current=$(git rev-parse --short HEAD)
branch=$(git branch --show-current)
[[ "$branch" == "main" ]] || {
    printf 'Error: el script solo actualiza la rama main; rama actual: %s\n' "$branch" >&2
    exit 1
}

printf 'Plugin: %s\n' "$PLUGIN_ID"
printf 'Versión local: %s\n' "$current"
printf 'Consultando actualizaciones...\n'
git fetch --prune origin main

if git diff --quiet HEAD origin/main; then
    printf 'El plugin ya está actualizado.\n'
    exit 0
fi

printf '\nCambios disponibles:\n'
git --no-pager log --oneline --decorate "HEAD..origin/main"
printf '\nArchivos modificados:\n'
git --no-pager diff --stat HEAD origin/main

if [[ "${1:-}" != "--yes" ]]; then
    read -r -p '¿Actualizar el plugin ahora? [s/N] ' answer
    case "${answer,,}" in
        s|si|sí|y|yes) ;;
        *) printf 'Actualización cancelada.\n'; exit 0 ;;
    esac
fi

git merge --ff-only origin/main

if command -v omarchy >/dev/null 2>&1; then
    if ! omarchy plugin validate "$REPO_DIR"; then
        printf 'Error: la actualización no pasó la validación del plugin.\n' >&2
        exit 1
    fi
fi

printf 'Plugin actualizado correctamente a %s.\n' "$(git rev-parse --short HEAD)"
