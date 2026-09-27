#!/bin/bash
# Выставляет ACL на каталог сайта, чтобы PHP-FPM мог обновлять ядро, ставить плагины и загружать файлы.
# На bind-mount (macOS Docker Desktop) POSIX ACL часто недоступен — тогда chmod.

if [[ ! -d "$WP_ROOT" ]]; then
  log warning "Каталог сайта не найден — права пропускаю"
else
  log info "Выставляю права на каталог сайта…"
  HTTPDUSER=$(ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d' ' -f1)
  [[ -n "$HTTPDUSER" ]] || HTTPDUSER=www-data

  mkdir -p "$WP_ROOT/wp-content/uploads" "$WP_ROOT/wp-content/upgrade"
  if setfacl -dR -m u:"$HTTPDUSER":rwX -m u:"$(whoami)":rwX "$WP_ROOT" 2>/dev/null \
     && setfacl -R -m u:"$HTTPDUSER":rwX -m u:"$(whoami)":rwX "$WP_ROOT" 2>/dev/null; then
    log success "Права на каталог сайта выставлены"
  else
    chmod -R a+rwX "$WP_ROOT"
    log success "Права на каталог сайта выставлены (chmod: ACL недоступен на этом томе)"
  fi
fi
