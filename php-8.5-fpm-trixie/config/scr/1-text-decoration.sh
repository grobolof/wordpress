#!/bin/bash
# Цветные статус-строки.
# Чтобы в docker logs сразу было видно этап, предупреждение и ошибку.

log() {
  local type=$1; shift
  local msg="$*" i
  local -A color=([error]='31' [warning]='33' [info]='36' [success]='32')
  local -A icon=([error]='❌' [warning]='⚠️' [info]='ℹ️' [success]='✅')
  local from=(а б в г д е ё ж з и й к л м н о п р с т у ф х ц ч ш щ ъ ы ь э ю я)
  local to=(А Б В Г Д Е Ё Ж З И Й К Л М Н О П Р С Т У Ф Х Ц Ч Ш Щ Ъ Ы Ь Э Ю Я)
  msg="${msg^^}"
  for i in "${!from[@]}"; do
    msg="${msg//${from[i]}/${to[i]}}"
  done
  printf "\033[%sm%s %s\033[0m\n" "${color[$type]:-37}" "${icon[$type]:-}" "$msg"
}
